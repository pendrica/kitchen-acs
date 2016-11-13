# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = 'kitchen-acs'
  spec.version       = '0.1.0'
  spec.authors       = ['Stuart Preston']
  spec.email         = ['stuart@pendrica.com']
  spec.summary       = 'Test Kitchen driver for Azure Container Service.'
  spec.description   = 'Test Kitchen driver for the Microsoft Azure Container Service'
  spec.homepage      = 'https://github.com/pendrica/kitchen-acs'
  spec.license       = 'Apache-2.0'

  spec.files         = Dir['LICENSE', 'README.md', 'CHANGELOG.md', 'lib/**/*']
  spec.require_paths = ['lib']

  spec.add_dependency 'sshkey', '~> 1', '>= 1.0.0'

  spec.add_development_dependency 'bundler', '~> 1.7'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rubocop', '~> 0'
  spec.add_development_dependency 'rspec', '~> 0'
end
