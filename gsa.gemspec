# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'gsa/version'

Gem::Specification.new do |spec|
  spec.name          = 'gsa'
  spec.version       = GSA::VERSION
  spec.authors       = ['Daniel J. Long', '1000Bulbs.com Dev Team']
  spec.email         = ['dlong@1000bulbs.com']

  spec.summary       = %q{
    One-line feeding, searching and faceting for Google Search Appliance (GSA)'
  }

  spec.description   = %q{
  Harness GSA indexing power easily and immediately with one-line feeding, 
  searching, and faceting. This gem is tailored for the use in commerce 
  and other such uses outside the scope of the out-of-the-box GSA 
  "internal search".
  }

  spec.homepage      = 'https://github.com/1000Bulbs/gsa'
  spec.license       = 'MIT'
  
  spec.files         = `git ls-files`.split($/)
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency 'bundler', '~> 1.3'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'webmock', '~> 1.13.0'
  spec.add_development_dependency 'vcr', '~> 2.5.0'
  spec.add_development_dependency 'simplecov', '~> 0.7.1'
  spec.add_development_dependency 'rspec', '~> 2.13.0'

  spec.add_runtime_dependency 'rest-client', '~> 1.6.7'
  spec.add_runtime_dependency 'activesupport', '~> 4.0.0'
  spec.add_runtime_dependency 'json', '~> 1.8.0'
  spec.add_runtime_dependency 'libxml-ruby', '~> 2.7.0'
end
