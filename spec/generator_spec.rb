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

  it "initializes with an activerecord class" do
    @generator = ToFactory::Generator.new User
    @generator.model_class.should == "User"
  end

  it "initializes with an activerecord instance" do
    user = User.create :name => "Jeff"
    @generator = ToFactory::Generator.new user
    @generator.model_class.should == "User"
  end

  it "initializes without an object" do
    @generator = ToFactory::Generator.new
    @generator.model_class.should be_nil
  end

  it "generates the first line of the factory" do
    @generator = ToFactory::Generator.new
    f = @generator.factory User
    output = <<-eof
Factory User do |u|
end
eof
    f.should ==  output[0..-2]
  end

  it "raises an exception without an AR object, when requesting attributes" do
    @generator = ToFactory::Generator.new User
    lambda{@generator.attribute :foo}.should raise_error ToFactory::MissingActiveRecordInstance
  end

  it "generates the lines for attributes" do
    User.create :name => "Jeff"
    @generator = ToFactory::Generator.new User.first
    @generator.attribute(:name).should == '  u.name "Jeff"'

  end

end
