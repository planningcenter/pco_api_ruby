require 'faraday'
require 'faraday_middleware'

module PCO
  module API
    URL = 'https://api.planningcenteronline.com'

    class Endpoint
      attr_reader :url, :last_result

      def initialize(url: URL, auth_token: nil, auth_secret: nil, connection: nil)
        @url = url
        @auth_token = auth_token
        @auth_secret = auth_secret
        @connection = connection || _build_connection
        @methods = {}
      end

      def method_missing(method_name, *args)
        @methods[method_name.to_s] ||= begin
          self.class.new(
            url: File.join(url, method_name.to_s),
            connection: @connection
          )
        end
      end

      def get(*args)
        result = @connection.get(@url, *args)
        @last_result = result
        case result.status
        when 200
          result.body
        else
          fail Errors::NotFound.new(result)
        end
      end

      private

      def _build_connection
        return unless @auth_token && @auth_secret
        Faraday.new(url: url) do |faraday|
          faraday.adapter :excon
          faraday.response :json, content_type: /\bjson$/
          faraday.basic_auth @auth_token, @auth_secret
        end
      end
    end
  end
end
