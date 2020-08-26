module PCO
  module API
    module Errors
      class AuthRequiredError < StandardError; end

      class BaseError < StandardError
        attr_reader :status, :detail

        def initialize(response)
          @status = response.status
          @detail = response.body
        end

        def to_s
          message
        end

        def message
          return detail.to_s unless detail.is_a?(Hash)
          detail['message'] || validation_message || detail.to_s
        end

        def inspect
          "<#{self.class.name} status=#{status} message=#{message.inspect} detail=#{detail.inspect}>"
        end

        private

        def validation_message
          return if Array(detail['errors']).empty?
          errors = detail['errors'].map do |error|
            error_to_string(error)
          end
          errors.uniq.join('; ')
        end

        def error_to_string(error)
          return unless error.is_a?(Hash)
          [
            "#{error['title']}:",
            error.fetch('meta', {})['resource'],
            error.fetch('source', {})['parameter'],
            error['detail']
          ].compact.join(' ')
        end
      end

      class ClientError         < BaseError;   end # 400..499
      class BadRequest          < ClientError; end # 400
      class Unauthorized        < ClientError; end # 401
      class Forbidden           < ClientError; end # 403
      class NotFound            < ClientError; end # 404
      class MethodNotAllowed    < ClientError; end # 405
      class UnprocessableEntity < ClientError; end # 422
      class TooManyRequests     < ClientError; end # 429

      class ServerError         < BaseError;   end # 500..599
      class InternalServerError < ServerError; end # 500
    end
  end
end
