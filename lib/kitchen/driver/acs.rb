require 'kitchen'
require 'kitchen/driver/credentials'
require 'net/ssh'

module Kitchen
  module Driver
    #
    # Acs - Azure Container Service
    #
    class Acs < Kitchen::Driver::Base
      default_config(:image) do |_config|
        ''
      end

      default_config(:username) do |_config|
        'root'
      end

      default_config(:password) do |_config|
        'root'
      end

      default_config(:port) do |_config|
        80
      end

      default_config(:acs_management_hostname) do |_config|
        'pendrica-acs-mgmt.westeurope.cloudapp.azure.com'
      end

      default_config(:acs_management_username) do |_config|
        'azure'
      end

      default_config(:acs_management_privatekey) do |_config|
        '~/.ssh/id_kitchen-azurerm'
      end

      default_config(:acs_management_port) do |_config|
        2200
      end

      default_config(:acs_agents_hostname) do |_config|
        'pendrica-acs-agents.westeurope.cloudapp.azure.com'
      end

      default_config(:docker_swarm_port) do |_config|
        2375
      end

      def create(state)
        info "Connecting to Azure Container Service/Docker Swarm Manager: #{config[:acs_management_hostname]}"
        Net::SSH.start(
          config[:acs_management_hostname],
          config[:acs_management_username],
          port: config[:acs_management_port],
          host_key: 'ssh-rsa',
          paranoid: Net::SSH::Verifiers::Null.new,
          keys: [config[:acs_management_privatekey]]) do |ssh|
            info "Pulling image: #{config[:image]}"
            info ssh.exec!("docker -H :#{config[:docker_swarm_port]} pull #{instance.driver[:image]}").strip
            container_id = ssh.exec!("docker -H :#{config[:docker_swarm_port]} run -dit --name #{instance.name} -p #{instance.transport[:port]}:22 #{instance.driver[:image]} ").strip
            raise container_id unless container_id.index('Error').nil?
            info "Container Id: #{container_id}"
            state[:container_id] = container_id
          end
        state[:hostname] = config[:acs_agents_hostname]
        state[:username] = instance.transport[:username]
        state[:password] = instance.transport[:password]
        state[:port] = config[:port]
      end

      def destroy(state)
        return if state[:container_id].nil?

        Net::SSH.start(
          config[:acs_management_hostname],
          config[:acs_management_username],
          port: config[:acs_management_port],
          host_key: 'ssh-rsa',
          paranoid: Net::SSH::Verifiers::Null.new,
          keys: [config[:acs_management_privatekey]]) do |ssh|
          info "Stopping container: #{state[:container_id]}"
          stop = ssh.exec!("docker -H :#{config[:docker_swarm_port]} stop #{state[:container_id]}").strip
          raise stop unless stop.index('Error').nil?
          info "Deleting container: #{state[:container_id]}"
          delete = ssh.exec!("docker -H :#{config[:docker_swarm_port]} rm #{state[:container_id]}").strip
          raise delete unless delete.index('Error').nil?
        end

        state.delete(:container_id)
        state.delete(:hostname)
        state.delete(:username)
        state.delete(:password)
        state.delete(:port)
      end
    end
  end
end
