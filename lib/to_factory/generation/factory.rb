module ToFactory
  module Generation
    class Factory
      def initialize(object, name)
        unless object.is_a? ActiveRecord::Base
          message = "Generation::Factory requires initializing with an ActiveRecord::Base instance"
          message << "\n  but received #{object.inspect}"
          raise ToFactory::MissingActiveRecordInstanceException.new(message)
        end

        @name = add_quotes name
        @attributes = object.attributes
      end

      def to_factory(parent_name=nil)
        header(parent_name) do
          to_skip = [:id, :created_at, :updated_at]
          attributes = @attributes.delete_if{|key, _| to_skip.include? key.to_sym}

          attributes.map do |attr, value|
            factory_attribute(attr, value)
          end.sort.join("\n") << "\n"
        end
      end

      def header(parent_name=nil, &block)
        if ToFactory.new_syntax?
          modern_header parent_name, &block
        else
          header_factory_girl_1 parent_name, &block
        end
      end

      def modern_header(parent_name=nil, &block)
        generic_header(parent_name, "factory", "", &block)
      end

      def header_factory_girl_1(parent_name=nil, &block)
        generic_header(parent_name, "Factory.define", "|o|", &block)
      end

      def factory_attribute(attr, value)
        attribute = "#{attr} #{inspect_value(value)}"

        if ToFactory.new_syntax?
          "    #{attribute}"
        else
          "  o.#{attribute}"
        end
      end

      private

      def generic_header(parent_name, factory_start, block_arg, &block)
        out =  "  #{factory_start}(:#{@name}#{parent_clause(parent_name)}) do#{block_arg}\n"
        out << yield.to_s
        out << "  end\n"
      end

      def parent_clause(name)
        name ?  ", :parent => :#{add_quotes name}" : ""
      end

      def add_quotes(name)
        name = name.to_s

        if name["/"]
          if name[/^".*"$/]
            name
          else
            "\"#{name}\""
          end
        else
          name
        end
      end

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
