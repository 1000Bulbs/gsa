Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = 'gsa'
  s.version     = '0.5.0'
  s.summary     = 'One-line feeding, searching and faceting for Google Search Appliance (GSA)'
  s.description = <<-EOF
  Harness GSA indexing power easily and immediately with one-line feeding, 
  searching, and faceting. This gem is tailored for the use in commerce 
  and other such uses outside the scope of the out-of-the-box GSA 
  "internal search".
  EOF

  s.license     = 'MIT'

  s.date        = '2013-09-19'
  s.authors     = ['1000Bulbs.com']
  s.email       = ['dlong@1000bulbs.com']
  s.homepage    = 'https://rubygems.org/gems/gsa'

  s.files         = Dir['lib/ *.rb']
  s.files        += Dir['lib/gsa/ *.rb']
  s.files        += Dir['lib/gsa/modules/ *.rb']

  s.test_files    = Dir['spec/ *.rb']
  s.test_files   += Dir['spec/lib/ *rb']

  s.require_paths = ["lib"]

  s.add_runtime_dependency 'rest-client', '~> 1.6.7'
  s.add_runtime_dependency 'activesuppoert', '~> 4.0.0'
  s.add_runtime_dependency 'json', '~> 1.8.0'

  s.add_development_dependency 'webmock', '~> 1.13.0'
  s.add_development_dependency 'vcr', '~> 2.5.0'
  s.add_development_dependency 'simplecov', '~> 0.7.1'
end
