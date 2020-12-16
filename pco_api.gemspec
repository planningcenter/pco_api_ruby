# frozen_string_literal: true

$LOAD_PATH.push File.expand_path('lib', __dir__)

require 'pco/api/version'

Gem::Specification.new do |s|
  s.name        = 'pco_api'
  s.version     = PCO::API::VERSION
  s.homepage    = 'https://github.com/planningcenter/pco_api_ruby'
  s.summary     = 'API wrapper for api.planningcenteronline.com'
  s.description = 'pco_api is a gem for working with the RESTful JSON API at api.planningcenteronline.com using HTTP basic auth or OAuth 2.0. This library can talk to any endpoint the API provides, since it is written to build endpoint URLs dynamically using method_missing.'
  s.author      = 'Planning Center Online'
  s.license     = 'MIT'
  s.email       = 'support@planningcenteronline.com'

  s.required_ruby_version = '>= 2.6.0'

  s.files = Dir['lib/**/*', 'README.md']
  s.test_files = Dir['spec/**/*']

  s.add_dependency 'excon', '>= 0.71.0'
  s.add_dependency 'faraday', '~> 0.10'
  s.add_dependency 'faraday_middleware', '~> 0.10'
  s.add_development_dependency 'pry', '~> 0.10'
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'webmock', '~> 1.21'
end
