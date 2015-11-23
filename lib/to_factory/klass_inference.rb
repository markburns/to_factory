module ToFactory
  class CannotInferClass < ArgumentError
    def initialize(message)
      super message.inspect
    end
  end

  class KlassInference
    def initialize(representations)
      @mapping = {}

      representations.each do |r|
        set_mapping_from(r)
      end
    end

    def infer(factory_name, count = 0)
      count += 1
      result = @mapping[factory_name]
      return [result, count] if result.is_a? Class

      fail CannotInferClass.new(factory_name) if result.nil?

      infer(result, count)
    end

    private

    def set_mapping_from(r)
      if parent_klass = to_const(r.parent_name)
        @mapping[r.parent_name] = parent_klass
      end

      @mapping[r.name] =
        if factory_klass = to_const(r.name)
          factory_klass
        else
          r.parent_name
        end
    end

    def to_const(factory_name)
      factory_name.to_s.camelize.constantize
    rescue NameError
      nil
    end
  end
end
