module ToFactory
  module Parsing
    class Hierarchy
      def organize(input)
        collection = Collection.new(input)
        input.each do |name, _, definition|
          collection.append_to_list(name, definition)
        end

        collection.lists
      end
    end

    class Collection
      attr_reader :lists
      def initialize(input)
        @inference = klass_inference(input)
        @lists = []
      end

      def append_to_list(name, definition)
        list_for(name).append(name, definition)
      end

      private

      def list_for(name)
        klass = @inference.infer(name)

        list = @lists.find{|l| l.klass == klass}

        if list.nil?
          list = List.new(klass, @inference)
          @lists << list
        end

        list
      end

      def klass_inference(input)
        KlassInference.new.tap do |k|
          k.setup(input)
        end
      end
    end

    class List
      attr_reader :klass

      def initialize(klass, inference)
        @inference = inference
        @klass = klass
        @internal_list = []
        @mapping = {}
      end

      def append(item, definition)
        @mapping[item] = definition
      end

      def to_a
        @mapping.sort do |(item_a, def_a),(item_b, def_b) |
          debugger
        end
      end
    end

  end
end
