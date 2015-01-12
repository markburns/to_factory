begin
  require "codeclimate-test-reporter"
  CodeClimate::TestReporter.start
rescue LoadError
  #ignore on ruby 1.8.x
end

require 'active_record'
require 'active_support/core_ext/string'
require 'active_support/core_ext/hash'
require "sqlite3"
require "database_cleaner"

begin
  require "pry-byebug"
rescue LoadError
  begin
    require "ruby-debug"
  rescue LoadError
    $stderr.puts "No debugger available for #{RUBY_VERSION}"
  end
end

require "to_factory"

require "./spec/support/models/user"
require "./spec/support/models/project"
require "./spec/support/match_sexp"
require "./spec/support/data_creation"

RSpec.configure do |config|
  config.include ToFactory::DataCreation

  config.before :suite do
    ActiveRecord::Base.tap do |base|
      config = {:adapter => "sqlite3", :database => "spec/db/test.sqlite3"}
      base.configurations = {:test => config}.with_indifferent_access
      base.establish_connection :test
    end

    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.clean_with(:truncation)
    DatabaseCleaner.start
  end

  config.before(:each) do
    FileUtils.rm_rf "tmp/factories"
    DatabaseCleaner.clean
    ToFactory.reset_config!
    ToFactory.models = "./spec/support/models"
    ToFactory.factories = "./tmp/factories"
  end

  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end
end
