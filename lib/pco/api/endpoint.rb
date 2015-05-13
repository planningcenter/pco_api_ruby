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
        @cache = {}
      end

      def method_missing(method_name, *_args)
        _build_endpoint(method_name.to_s)
      end

      def [](id)
        _build_endpoint(id.to_s)
      end

      def respond_to?(method_name)
        endpoint = _build_endpoint(method_name.to_s)
        endpoint.head
      end

      def head
        @connection.head(@url)
      end

      def get(params = {})
        @last_result = @connection.get(@url, params)
        _build_response(@last_result)
      end

      def post(body = {})
        @last_result = @connection.post(@url) do |req|
          req.body = body.to_json
        end
        _build_response(@last_result)
      end

      def patch(body = {})
        @last_result = @connection.patch(@url) do |req|
          req.body = body.to_json
        end
        _build_response(@last_result)
      end

      def delete
        @last_result = @connection.delete(@url)
        if @last_result.status == 204
          true
        else
          _build_response(@last_result)
        end
      end

      private

      def _build_response(result)
        case result.status
        when 200..299
          result.body
        when 404
          fail Errors::NotFound, result
        when 400..499
          fail Errors::ClientError, result
        when 500..599
          fail Errors::ServerError, result
        else
          fail "unknown status #{result.status}"
        end
      end

      def _build_endpoint(path)
        @cache[path] ||= begin
          self.class.new(
            url: File.join(url, path.to_s),
            connection: @connection
          )
        end
      end

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
