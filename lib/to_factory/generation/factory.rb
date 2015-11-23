module ToFactory
  module Generation
    class Factory
      def initialize(representation)
        @representation = representation
      end

      def name
        add_quotes @representation.name
      end

      def to_factory
        header do
          attributes.map do |attr, value|
            factory_attribute(attr, value)
          end.sort.join("\n") << "\n"
        end
      end

      def header(&block)
        generic_header("  factory", "", "  end", &block)
      end

      def factory_attribute(attr, value)
        Attribute.new(attr, value).to_s
      end

      def attributes
        to_skip = [:id, :created_at, :created_on, :updated_at, :updated_on]

        @representation.attributes.delete_if { |key, _| key.nil? || to_skip.include?(key.to_sym) }
      end

      private

      def parent_name
        @representation.parent_name
      end

      def generic_header(factory_start, block_arg, ending, &_block)
        out =  "#{factory_start}(:#{name}#{parent_clause}) do#{block_arg}\n"
        out << yield.to_s
        out << "#{ending}\n"
      end

      def parent_clause
        has_parent? ? ", :parent => :#{add_quotes parent_name}" : ""
      end

      def has_parent?
        parent_name.to_s.length > 0
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
    end
  end
end
