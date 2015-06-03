require_relative "lib/pco/api/version"

Gem::Specification.new do |s|
  s.name        = "pco_api"
  s.version     = PCO::API::VERSION
  s.homepage    = "https://github.com/planningcenter/pco_api_ruby"
  s.summary     = "Ruby wrapper for the RESTful PCO API"
  s.description = "Ruby wrapper for the RESTful PCO API"
  s.author      = ["Planning Center Online"]

  s.files = Dir["lib/**/*", "README.md"]
  s.test_files = Dir["spec/**/*"]

  s.add_dependency "faraday", "~> 0.9.1"
  s.add_dependency "faraday_middleware", "~> 0.9.1"
  s.add_dependency "excon", ">= 0.30.0"
  s.add_development_dependency "rspec", "~> 3.2.0"
  s.add_development_dependency "webmock", "~> 1.21.0"
  s.add_development_dependency "pry", "~> 0.10.1"
end
