module ToFactory
  module Generation
    class Attribute
      def initialize(attribute, value)
        @attribute = attribute
        @value = value
      end

      def to_s
        attribute = "#{@attribute} #{inspect_value(@value)}"

        if ToFactory.new_syntax?
          "    #{attribute}"
        else
          "  o.#{attribute}"
        end
      end

      def <=>(other)
        @attribute <=> other
      end

      def ==(other)
        to_s == other.to_s
      end

      private

      def inspect_value(value)
        case value
        when Time, DateTime
          time = in_utc(value).strftime("%Y-%m-%dT%H:%M%Z").inspect
          time.gsub(/UTC"$/, "Z\"").gsub(/GMT"$/, "Z\"")
        when BigDecimal
          value.to_f.inspect
        when Hash
          hash = value.inject({}){|result, (k, v)| result[k] = inspect_value(v); result}
        when Array
          value.map{|v| inspect_value(v)}
        else
          value.inspect
        end
      end

      def in_utc(time)
        time.utc
      end
    end
  end
end


