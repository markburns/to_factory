require File.expand_path('spec/spec_helper')

describe ToFactory::Generator do
  def options
    YAML::load File.read('spec/config/database.yml')
  end

  def connect
    AR::Base.establish_connection options rescue nil
    AR::Base.connection
  end

  before(:all) do
    ActiveRecord.tap do |AR|
      connect
      AR::Base.connection.drop_database options[:database] rescue nil

      begin
        # Create the SQLite database
        connect
        ActiveRecord::Base.connection
      rescue Exception => e
        $stderr.puts e, *(e.backtrace)
        $stderr.puts "Couldn't create database for #{config.inspect}"
      end

      AR::Migrator.migrate('db/migrate')
      AR::Base.connection.execute "VACUUM"
      class User < AR::Base; end
    end
  end

  it "generates the first line of the factory" do
    @generator = ToFactory::Generator.new
    f = @generator.factory User
    f.should == <<-eof
Factory User do |f|
end
    eof
  end

end
