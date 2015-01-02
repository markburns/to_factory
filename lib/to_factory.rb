require "to_factory/version"
require "to_factory/generator"
require "to_factory/hash_collision_deteection"
require "to_factory/file_system"
require "to_factory/file_writer"
require "to_factory/model_finder"
require "to_factory/dispatcher"
require "to_factory/factory_collection"

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

def ToFactory(args)
  factories = ToFactory::Dispatcher.new(args).dispatch

  FileSystem.new(factories)
end

if defined?(Rails)
  unless Rails.respond_to?(:configuration)
    #FactoryGirl 1.3.x expects this method, but it isn't defined in Rails 2.0.2
    def Rails.configuration
      OpenStruct.new
    end
  end
end
