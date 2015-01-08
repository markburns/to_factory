require "deep_merge"

require "to_factory/version"
require "to_factory/config"
require "to_factory/generation/factory"
require "to_factory/generation/attribute"
require "to_factory/collation"
require "to_factory/file_writer"
require "to_factory/finders/model"
require "to_factory/finders/factory"
require "to_factory/representation"
require "to_factory/file_sync"
require "to_factory/parsing/file"
require "to_factory/klass_inference"

module ToFactory
  class MissingActiveRecordInstanceException < Exception;end

  class << self
    def new_syntax?
      require "factory_girl"
      if FactoryGirl::VERSION.to_s[0..0].to_i > 1
        true
      else
        false
      end
    rescue NameError, ArgumentError
      false
    end

    def definitions
      results = Finders::Factory.new.call
      results.map{|_, r| r.keys}.flatten
    end
  end
end

public

def ToFactory(args=nil)
  exclusions = if args.is_a?(Hash)
                 exclusions = Array(args.delete(:exclude) || [])
                 args = nil if args.keys.length == 0
                 exclusions
               else
                 []
               end

  meth = ToFactory::FileSync.method(:new)
  sync = args ? meth.call(args) : meth.call

  sync.perform(exclusions)
end

if defined?(Rails)
  unless Rails.respond_to?(:configuration)
    #FactoryGirl 1.3.x expects this method, but it isn't defined in Rails 2.0.2
    def Rails.configuration
      OpenStruct.new
    end
  end
end
