require "to_factory/version"
require "to_factory/config"
require "to_factory/generator"
require "to_factory/hash_collision_detection"
require "to_factory/file_system"
require "to_factory/file_writer"
require "to_factory/factory_collection"
require "to_factory/parsing/file"
require "to_factory/model_finder"
require "to_factory/dispatcher"

module ToFactory
  class MissingActiveRecordInstanceException < Exception;end

  class << self
    def generate!(instance=nil)
      if instance
        ToFactory::Generator.new(instance).to_factory
      else
        FileWriter.new.all!
      end
    end

    def new_syntax?
      require "factory_girl"
      if FactoryGirl::VERSION.to_s[0].to_i > 1
        true
      else
        false
      end
    rescue NameError
      false
    end
  end
end

public

def ToFactory(args)
  if args.is_a?(ActiveRecord::Base)
    ToFactory.generate! args
  else
    ToFactory::Dispatcher.new(args).dispatch
  end
end

if defined?(Rails)
  unless Rails.respond_to?(:configuration)
    #FactoryGirl 1.3.x expects this method, but it isn't defined in Rails 2.0.2
    def Rails.configuration
      OpenStruct.new
    end
  end
end
