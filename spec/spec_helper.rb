require 'active_record'
require 'fileutils'
require 'active_support/core_ext/string'
require 'active_support/core_ext/hash'
require "to_factory"
require "sqlite3"

begin
  case RUBY_VERSION
  when /^1.8.7/
    require "ruby-debug"
  when /^1.9.\d/
    require "debugger"
  when /^2.\d/
    require "pry-byebug"
  end
rescue LoadError
  $stderr.puts "No debugger available for #{RUBY_VERSION}"
end

require "./spec/support/user"

RSpec.configure do |config|
  config.before :suite do
    ActiveRecord::Base.tap do |base|
      config = {:adapter => "sqlite3", :database => "spec/db/test.sqlite3"}
      base.configurations = {:test => config}.with_indifferent_access
      base.establish_connection :test
    end
  end

  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end
end
