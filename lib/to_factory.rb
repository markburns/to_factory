require "to_factory/version"
require "to_factory/generator"
require "to_factory/auto_generator"

ActiveRecord::Base.send(:include, ToFactory)

module ToFactory
  class << self
    def generate!(args)
        if args.is_a?(Array)
          return generate_all!(*args)
        elsif args.is_a?(Hash)
          return from_options!(args)
        end
    end

    private

    def generate_all!(*path)
      AutoGenerator.new(path).all!
    end

    def from_options!(options)
      model_dir   = options.fetch(:models)
      factory_dir = options.fetch(:factories)

      AutoGenerator.new(model_dir, factory_dir).all!
    end
  end
end
