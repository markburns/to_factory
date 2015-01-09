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
        if ToFactory.new_syntax?
          generic_header("  factory", "", "  end", &block)
        else
          generic_header("Factory.define", " |o|", "end", &block)
        end
      end

      def factory_attribute(attr, value)
        Attribute.new(attr, value).to_s
      end

      private

      def attributes
        to_skip = [:id, :created_at, :updated_at]

        @representation.attributes.delete_if{|key, _| to_skip.include? key.to_sym}
      end

      def parent_name
        @representation.parent_name
      end

      def generic_header(factory_start, block_arg, ending, &block)
        out =  "#{factory_start}(:#{name}#{parent_clause}) do#{block_arg}\n"
        out << yield.to_s
        out << "#{ending}\n"
      end

      def parent_clause
        has_parent? ?  ", :parent => :#{add_quotes parent_name}" : ""
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
