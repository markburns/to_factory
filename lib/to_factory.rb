require "to_factory/version"
require "to_factory/generator"
require "to_factory/auto_generator"

module ToFactory
  class MissingActiveRecordInstanceException < Exception;end
  class MustBeActiveRecordSubClassException < Exception;end

  def self.included base
    base.class_eval do
      unless self.ancestors.include? ActiveRecord::Base
        raise MustBeActiveRecordSubClassException
      end
    end

    base.instance_eval do
      define_method :to_factory do
        Generator.new(self).factory_with_attributes
      end
    end
  end

  class << self
    def generate!(options)
      model_dir   = options.fetch(:models)
      factory_dir = options.fetch(:factories)

      AutoGenerator.new(model_dir, factory_dir).all!
    end
  end
end

ActiveRecord::Base.send(:include, ToFactory)
