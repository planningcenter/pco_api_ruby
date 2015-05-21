module PCO
  module API
    module Errors
      class AuthRequiredError < StandardError; end

      class BaseError < StandardError
        attr_reader :status

        def initialize(response)
          @status = response.status
          @message = response.body
        end

        def to_s
          @message
        end

        def inspect
          "<#{self.class.name} status=#{@status} message=#{@message}>"
        end
      end

      class NotFound    < BaseError; end
      class ClientError < BaseError; end
      class ServerError < BaseError; end
    end
  end
end
