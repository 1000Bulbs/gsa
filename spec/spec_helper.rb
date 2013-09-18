require 'webmock/rspec'
require 'vcr'
require 'simplecov'
require 'fixtures'

SimpleCov.start

require_relative '../lib/gsa'

VCR.configure do |config|
  config.cassette_library_dir = 'fixtures/cassette_library'
  config.hook_into :webmock
  config.ignore_localhost = true
  config.default_cassette_options = { :record => :none }
end
