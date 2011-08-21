require 'rubygems'
require 'spork'
require 'spork/ext/ruby-debug'

Spork.prefork do
  require 'active_record'
  require 'rspec'
  require 'yaml'
  require 'fileutils'
  require 'ruby-debug'
  require 'active_support/core_ext/string'
  require 'active_support/core_ext/hash'
end

Spork.each_run do
  Dir['lib/**/*.rb'].each{|f| require f unless f=="lib/to_factory/version.rb"}
end
