require_relative 'api/endpoint'
require_relative 'api/errors'
require_relative 'api/version'

module PCO
  module API
    class << self
      def new(**args)
        Endpoint.new(**args)
      end
    end
  end
end
