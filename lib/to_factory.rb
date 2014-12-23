require "to_factory/version"
require "to_factory/generator"
require "to_factory/auto_generator"

ActiveRecord::Base.send(:include, ToFactory)

module ToFactory
  class << self
    def generate!(args)
      model_dir   = options.fetch(:models)
      factory_dir = options.fetch(:factories)

      AutoGenerator.new(model_dir, factory_dir).all!
    end
  end
end
