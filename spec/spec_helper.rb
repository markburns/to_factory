require 'active_record'
require 'yaml'
require 'fileutils'
require 'ruby-debug'
Dir['lib/**/*.rb'].each{|f| require f unless f=="lib/to_factory/version.rb"}


