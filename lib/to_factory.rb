require "to_factory/version"
require "to_factory/generator"
require "to_factory/file_writer"

module ToFactory
  class MissingActiveRecordInstanceException < Exception;end

  class << self
    def generate!(options={})
      model_dir   = options[:models] || "app/models"
      factory_dir = options[:factories] || "spec/factories"

      FileWriter.new(model_dir, factory_dir).all!
    end
  end
end

public

def ToFactory(instance)
  ToFactory::Generator.new(instance).to_factory
end

if defined?(Rails)
  unless Rails.respond_to?(:configuration)
    #FactoryGirl 1.3.x expects this method, but it isn't defined in Rails 2.0.2
    def Rails.configuration
      OpenStruct.new
    end
  end
end
