module ToFactory
  module Generation
    class Attribute
      attr_writer :parser

      def initialize(attribute, value)
        @attribute = attribute
        @value = value
      end

      def to_s
        setter = "#{@attribute}#{inspect_value(@value)}"
        "    #{setter}"
      end

      def inspect_value(value, nested = false)
        formatted = format(value, nested)

        formatted = " { #{formatted} }" if !value.is_a?(Hash) && !nested

        formatted
      end

      def format(value, nested = false)
        case value
        when Time, DateTime
          inspect_time(value)
        when Date
          value.to_s.inspect
        when BigDecimal
          "BigDecimal.new(#{value.to_s.inspect})"
        when Hash
          inspect_hash(value, nested)
        when Array
          inspect_array(value, nested)
        when String
          validate_parseable!(value).inspect
        else
          value.inspect
        end
      end

      private

      def validate_parseable!(value)
        return value if parse(value)

        'ToFactory: RubyParser exception parsing this attribute'
      end

      def parse(value)
        @parser ||= RubyParser.new
        @parser.parse(value)
        true
      rescue StandardError
        false
      end

      def inspect_time(value)
        value = value.strftime('%Y-%m-%dT%H:%M %Z').inspect
        value.gsub!(/GMT/, 'UTC')
        value
      end

      def inspect_hash(value, nested)
        formatted = value.keys.inject([]) do |a, key|
          a << key_value_pair(key, value)
        end.join(', ')

        if nested
          "{#{formatted}}"
        else
          " { {#{formatted}} }"
        end
      end

      def inspect_array(value, nested)
        values = value.map { |v| format(v, nested) }.join(', ')
        "[#{values}]"
      end

      def key_value_pair(key, value)
        formatted_key = inspect_value(key, true)
        formatted_value = inspect_value(value.fetch(key), true)
        "#{formatted_key} => #{formatted_value}"
      end
    end
  end
end
