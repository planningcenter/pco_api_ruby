require 'faraday'
require 'faraday_middleware'

module PCO
  module API
    URL = 'https://api.planningcenteronline.com'

    class Response < Hash
      attr_accessor :headers
    end

    class Endpoint
      attr_reader :url, :last_result

      attr_accessor :retry_when_rate_limited

      def initialize(url: URL, oauth_access_token: nil, basic_auth_token: nil, basic_auth_secret: nil, connection: nil)
        @url = url
        @oauth_access_token = oauth_access_token
        @basic_auth_token = basic_auth_token
        @basic_auth_secret = basic_auth_secret
        @connection = connection || _build_connection
        @cache = {}
        @retry_when_rate_limited = true
      end

      def method_missing(method_name, *_args)
        _build_endpoint(method_name.to_s)
      end

      def [](id)
        _build_endpoint(id.to_s)
      end

      def respond_to?(method_name, _include_all = false)
        endpoint = _build_endpoint(method_name.to_s)
        begin
          endpoint.get
        rescue Errors::NotFound
          false
        else
          true
        end
      end

      def get(params = {})
        @last_result = @connection.get(@url, params)
        _build_response(@last_result)
      rescue Errors::TooManyRequests => e
        _retry_after_timeout?(e) ? retry : raise
      end

      def post(body = {})
        @last_result = @connection.post(@url) do |req|
          req.body = _build_body(body)
        end
        _build_response(@last_result)
      rescue Errors::TooManyRequests => e
        _retry_after_timeout?(e) ? retry : raise
      end

      def patch(body = {})
        @last_result = @connection.patch(@url) do |req|
          req.body = _build_body(body)
        end
        _build_response(@last_result)
      rescue Errors::TooManyRequests => e
        _retry_after_timeout?(e) ? retry : raise
      end

      def delete
        @last_result = @connection.delete(@url)
        if @last_result.status == 204
          true
        else
          _build_response(@last_result)
        end
      rescue Errors::TooManyRequests => e
        _retry_after_timeout?(e) ? retry : raise
      end

      private

      def _build_response(result)
        case result.status
        when 200..299
          res = Response[result.body]
          res.headers = result.headers
          res
        when 400
          fail Errors::BadRequest, result
        when 401
          fail Errors::Unauthorized, result
        when 403
          fail Errors::Forbidden, result
        when 404
          fail Errors::NotFound, result
        when 405
          fail Errors::MethodNotAllowed, result
        when 422
          fail Errors::UnprocessableEntity, result
        when 429
          fail Errors::TooManyRequests, result
        when 400..499
          fail Errors::ClientError, result
        when 500
          fail Errors::InternalServerError, result
        when 500..599
          fail Errors::ServerError, result
        else
          fail "unknown status #{result.status}"
        end
      end

      def _build_body(body)
        if _needs_url_encoded?
          Faraday::Utils.build_nested_query(body)
        else
          body.to_json
        end
      end

      def _needs_url_encoded?
        @url =~ /oauth\/[a-z]+\z/
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
        Faraday.new(url: url) do |faraday|
          faraday.response :json, content_type: /\bjson$/
          if @basic_auth_token && @basic_auth_secret
            faraday.basic_auth @basic_auth_token, @basic_auth_secret
          elsif @oauth_access_token
            faraday.headers['Authorization'] = "Bearer #{@oauth_access_token}"
          else
            fail Errors::AuthRequiredError, "You must specify either HTTP basic auth credentials or an OAuth2 access token."
          end
          faraday.adapter :excon
        end
      end

      def _retry_after_timeout?(e)
        if @retry_when_rate_limited
          secs = e.headers['Retry-After']
          Kernel.sleep(secs ? secs.to_i : 1)
          true
        else
          false
        end
      end
    end
  end
end
