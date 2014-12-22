require "to_factory/version"
require "to_factory/generator"
require "to_factory/auto_generator"

ActiveRecord::Base.send(:include, ToFactory)
