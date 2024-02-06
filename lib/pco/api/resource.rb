module PCO
  module API
    class Resource < Hash
      attr_accessor :response

      def type
        fetch('type')
      end

      def id
        fetch('id')
      end

      def attributes
        @attributes ||= OpenStruct.new(fetch('attributes'))
      end

      def relationships
        @relationships ||= _build_relationships
      end

      def included
        response&.included
      end

      def method_missing(m, *_args)
        if relationships.keys.include? m.to_s
          relationships.fetch(m.to_s)
        else
          super
        end
      end

      def inspect
        "#<#{self.class.name} type=#{type.inspect} id=#{id.inspect} attributes=#{attributes.inspect}>"
      end

      private

      def _build_relationships
        fetch('relationships', {}).each_with_object({}) do |(key, value), r|
          r[key] = Relationship.new(value, self).data
        end
      end
    end
  end
end
