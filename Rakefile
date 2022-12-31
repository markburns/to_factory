require "bundler/gem_tasks"
require 'byebug'

namespace :spec do
  def setup_db
    require "logger"
    require "active_record"
    ActiveRecord::Base.establish_connection(adapter: "sqlite3", database: "spec/db/test.sqlite3")
    ActiveRecord::Base.logger = Logger.new(File.open("tmp/database.log", "a"))
    ActiveRecord::Migrator.migrations_paths = File.expand_path("./spec/db/migrate")
  end

  desc "Migrate the database through scripts in db/migrate. Target specific version with VERSION=x"
  task :migrate_db do
    setup_db
    ActiveRecord::Tasks::DatabaseTasks.migrate
  end

  desc "Migrate down"
  task :migrate_down do
    setup_db
    ActiveRecord::Migrator.new.migrate(:down)
  end
end

begin
  require "rspec/core/rake_task"
  RSpec::Core::RakeTask.new do |t|
    t.rspec_opts = ["-c", "-f progress", "-r ./spec/spec_helper.rb"]
    t.pattern = "spec/**/*_spec.rb"
  end
  task default: :spec
rescue LoadError

end

begin
  require "rubocop/rake_task"

  RuboCop::RakeTask.new
rescue LoadError
end
