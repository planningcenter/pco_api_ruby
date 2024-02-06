module PCO
  module API
    class Response < Hash
      attr_accessor :headers

      def data
        return @data if defined? @data

        data_hash = fetch('data')

        case data_hash
        when Array
          @data = data_hash.map { |resource| _build_resource(resource) }
        when Hash
          @data = _build_resource(data_hash)
        else
          fail Errors::UnknownResponseData, self
        end

        return @data
      end

      def included
        @included ||= fetch('included', []).map { |resource| _build_resource(resource) }
      end

      # TODO
      def meta
        fetch('meta')
      end

      def inspect
        "#<#{self.class.name} headers=#{headers.inspect} data=#{data.inspect} included=#{included.inspect}>"
      end

      private

      def _build_resource(resource)
        Resource[resource].tap { |r| r.response = self }
      end
    end
  end
end
