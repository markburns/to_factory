module ToFactory
  module Generation
    class Factory
      def initialize(representation)
        @representation = representation
      end

      def name
        add_quotes @name
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
          modern_header &block
        else
          header_factory_girl_1 &block
        end
      end

      def modern_header(&block)
        generic_header("factory", "", &block)
      end

      def header_factory_girl_1(&block)
        generic_header("Factory.define", " |o|", &block)
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

      def generic_header(factory_start, block_arg, &block)
        debugger if name.blank?
        out =  "  #{factory_start}(:#{name}#{parent_clause}) do#{block_arg}\n"
        out << yield.to_s
        out << "  end\n"
      end

      def parent_clause
        parent_name ?  ", :parent => :#{add_quotes parent_name}" : ""
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
