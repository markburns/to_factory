module ToFactory
  class Dispatcher
    def initialize(args)
      @args = args
    end

    def dispatch
      case @args
      when ActiveRecord::Base
        generate(@args)
      when Hash
        dispatch_hash(@args)
      end
    end

    private

    def dispatch_hash(h)
      i = h[:items]
      if i.is_a?(ActiveRecord::Base)
        Array generate(i)
      elsif i.is_a?(Array)
        i.map{|a| generate(a)}
      end
    end

    def generate(instance)
      ToFactory::Generator.new(instance).to_factory
    end

  end
end


