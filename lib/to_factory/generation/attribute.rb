module ToFactory
  module Generation
    class Attribute
      def initialize(attribute, value)
        @attribute = attribute
        @value = value
      end

      def to_s
        setter = "#{@attribute}#{inspect_value(@value)}"

        if ToFactory.new_syntax?
          "    #{setter}"
        else
          "  o.#{setter}"
        end
      end

      def inspect_value(value)
        formatted = case value
        when Time, DateTime
          time = in_utc(value).strftime("%Y-%m-%dT%H:%M%Z").inspect
          time.gsub(/UTC"$/, "Z\"").gsub(/GMT"$/, "Z\"")
        when BigDecimal
          value.to_f.inspect
        when Hash
          formatted = value.inspect.gsub(/=>/, " => ")
          "(#{formatted})"
        when Array
          value.map{|v| inspect_value(v)}
        else
          value.inspect
        end

        unless value.is_a?(Hash)
          formatted = " #{formatted}"
        end

        formatted
      end

      def in_utc(time)
        time.utc
      end
    end
  end
end


