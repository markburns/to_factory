module ToFactory
  class << self
    attr_accessor :factories, :models

    def reset_config!
      @factories = nil
      @models = nil
    end

    def factories
      @factories ||= './spec/factories'
    end

    def models
      @models ||= './app/models'
    end
  end
end
