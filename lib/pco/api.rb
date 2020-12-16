# frozen_string_literal: true

require_relative 'api/endpoint'
require_relative 'api/errors'

module PCO
  module API
    module_function

    def new(*args)
      Endpoint.new(*args)
    end
  end
end
