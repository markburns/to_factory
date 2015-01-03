module ToFactory
  class Dispatcher
    def initialize(options)
      @options = options
    end

    def dispatch
      @collection = FactoryCollection.new
      @collection.read_from_file_system

      case @options
      when ActiveRecord::Base
        dispatch_hash(:items => @options)
      when Hash
        dispatch_hash(@options)
      end

      @collection.write!
    end

    private

    def dispatch_hash(h)
      i = h[:items]
      if i.is_a?(ActiveRecord::Base)
        @collection.add(*process_instance(i))

      elsif i.is_a?(Hash)
        i.each do |name, record|
          @collection.add(*process_instance(record, name))
        end
      end
    end

    def process_instance(i,name=nil)
      factory_definition = generate(i)
      name ||= i.class.name.underscore

      [i.class, name, factory_definition]
    end

    def generate(instance)
      ToFactory::Generator.new(instance).to_factory
    end


  end
end


