# frozen_string_literal: true

module PCO
  module API
    module Errors
      class AuthRequiredError < StandardError; end

      class BaseError < StandardError
        attr_reader :status, :detail

        def initialize(response)
          super
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

      class ClientError < BaseError
        # 400..499
      end

      class BadRequest < ClientError
        # 400
      end

      class Unauthorized < ClientError
        # 401
      end

      class Forbidden < ClientError
        # 403
      end

      class NotFound < ClientError
        # 404
      end

      class MethodNotAllowed < ClientError
        # 405
      end

      class UnprocessableEntity < ClientError
        # 422
      end

      class TooManyRequests < ClientError
        # 429
      end

      class ServerError < BaseError
        # 500..599
      end

      class InternalServerError < ServerError
        # 500
      end
    end
  end
end
