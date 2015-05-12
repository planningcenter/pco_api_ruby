module PCO
  module API
    module Errors
      class NotFound < StandardError
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
    end
  end
end
