require "to_factory/version"
require "to_factory/generator"
require "to_factory/auto_generator"

module ToFactory
  class MissingActiveRecordInstanceException < Exception;end

  class << self
    def generate!(options)
      model_dir   = options.fetch(:models)
      factory_dir = options.fetch(:factories)

      AutoGenerator.new(model_dir, factory_dir).all!
    end
  end
end

public

def ToFactory(instance)
  ToFactory::Generator.new(instance).to_factory
end
