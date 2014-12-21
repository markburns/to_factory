require "bundler/gem_tasks"

namespace :spec do
  desc "Migrate the database through scripts in db/migrate. Target specific version with VERSION=x"
  task :migrate_db do
    require 'logger'
    require 'active_record'
    ActiveRecord::Base.establish_connection(adapter: "sqlite3", database: "spec/db/test.sqlite3")
    ActiveRecord::Base.logger = Logger.new(File.open('tmp/database.log', 'a'))
    ActiveRecord::Migrator.migrate('spec/db/migrate')
  end
end
