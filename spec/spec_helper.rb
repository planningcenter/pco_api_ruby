require 'webmock/rspec'
require_relative '../lib/pco_api'
require 'json'

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.color = true
  config.order = 'random'
  config.filter_run focus: true
  config.run_all_when_everything_filtered = true

  def json_fixture(file_name)
    JSON.parse(File.read(File.join(__dir__, 'fixtures', file_name)))
  end
end
