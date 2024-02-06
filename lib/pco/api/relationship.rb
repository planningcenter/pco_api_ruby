module PCO
  module API
    class Relationship < Hash
      attr_reader :head, :tail

      def initialize(head, tail)
        @head = head
        @tail = tail
      end

      def present?
        data.present?
      end

      # optional, could be nil
      def link
        dig('links', 'related')
      end

      def data
        return @data if defined? @data

        d = head.fetch('data', nil)

        case d
        when Array
          @data = d.map { |data_item| lookup_included_resource(data_item['type'], data_item['id']) }
        when Hash
          @data = lookup_included_resource(d['type'], d['id'])
        when nil
          nil
        else
          throw "Unknown Relationship"
        end

        return @data
      end

      def lookup_included_resource(type, id)
        # TODO: Perhaps throw error if lookup fails?
        tail.included.find { |resource| type == resource.type  && id == resource.id }
      end
    end
  end
end
