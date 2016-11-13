# kitchen-acs (docker swarm)

**kitchen-acs** is a driver for the popular test harness [Test Kitchen](http://kitchen.ci) that allows container resources to be provisioned via Azure Container Service prior to testing. 

**Only works with Docker Swarm**

This driver was created as part of a hack day at Chef in November 2016. YMMV!

## Example kitchen.yml

```yaml
---
driver:
  name: acs

driver_config:
  acs_management_hostname: pendrica-acs-mgmt.westeurope.cloudapp.azure.com
  acs_agents_hostname: pendrica-acs-agents.westeurope.cloudapp.azure.com
  acs_management_username: azure
  acs_management_privatekey: ~/.ssh/id_kitchen-azurerm

provisioner:
  name: chef_zero

verifier:
  name: inspec

platforms:
  - name: ubuntu-14.04-1
    driver:
      image: rastasheep/ubuntu-sshd:14.04
    transport:
      port: 80
      username: root
      password: root

suites:
  - name: default
    run_list:
      - recipe[helloworld::default]
    verifier:
      inspec_tests:
        - test/recipes
    attributes:
```

## Notes
- In a default ACS installation, only ports 80, 443 and 8080 are forwarded to the agent by default.  If you have more than 3 containers that require testing in parallel you will need to modify your ACS agent load balancer to add the additional ports.

[![Gem Version](https://badge.fury.io/rb/kitchen-acs.svg)](http://badge.fury.io/rb/kitchen-acs) [![Build Status](https://travis-ci.org/pendrica/kitchen-acs.svg)](https://travis-ci.org/pendrica/kitchen-acs)
