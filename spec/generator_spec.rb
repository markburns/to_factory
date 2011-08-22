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
      class User < AR::Base; end
   end
  end

  before(:each) do
    User.destroy_all
    ActiveRecord::Base.connection.execute "delete from sqlite_sequence where name = 'users'"
  end

  context "with an active record class but no instance" do
    before do
      @generator = ToFactory::Generator.new User
      User.create :id => 1, :name => 'Tom',   :email => 'blah@example.com',  :some_id => 7
      User.create :id => 2, :name => 'James', :email => 'james@example.com', :some_id => 8
    end

    it "initializes" do
      @generator.model_class.should == User
    end

    let(:user_factory_1) do
      user_factory_1 = <<-eof
Factory.define :user do |u|
  u.email "blah@example.com"
  u.name "Tom"
  u.some_id 7
end
      eof
      user_factory_1.chop
    end
    let(:user_factory_2) do
      user_factory_2 = <<-eof
Factory.define :user do |u|
  u.email "james@example.com"
  u.name "James"
  u.some_id 8
end
      eof
      user_factory_2.chop
    end
    context "looking up attributes" do
      it "takes a key value for id" do
        out = @generator.factory_for :id => 1
        out.should == user_factory_1
      end

      it "takes an integer for id" do
        out = @generator.factory_for 1
        out.should == user_factory_1
      end

      it "takes a key value and does a lookup" do
        out = @generator.factory_for :name => 'Tom'
        out.should == user_factory_1

        out = @generator.factory_for :name => 'James'
        out.should == user_factory_2
      end

      it "takes multiple keys and does a lookup" do
        out = @generator.factory_for :id => 1, :name => 'Tom'
      end

      context "with invalid attributes" do
        it "raises an exception" do
          lambda{@generator.factory_for :id => 1000}.should raise_error ActiveRecord::RecordNotFound
        end
      end
    end
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
    @generator = ToFactory::Generator.new User
    f = @generator.factory
    output = <<-eof
Factory.define :user do |u|
end
    eof
    f.should ==  output.chop
  end


  it "raises an exception without an AR object, when requesting attributes" do
    @generator = ToFactory::Generator.new User
    lambda{@generator.factory_attribute :foo}.should raise_error ToFactory::MissingActiveRecordInstanceException
  end

  context "with a user in the database" do
    before do
      User.create :name => "Jeff", :email => "test@example.com", :some_id => 8
      @generator = ToFactory::Generator.new user
    end

    let(:user){ User.first}

    it "generates lines for multiple the attributes" do
      @generator.factory_attribute(:name). should == '  u.name "Jeff"'
      @generator.factory_attribute(:email).should == '  u.email "test@example.com"'
    end

    let(:expected) do
      expected = <<-eof
Factory.define :user do |u|
  u.email "test@example.com"
  u.name "Jeff"
  u.some_id 8
end
      eof
      expected.chop
    end

    it "generates the full factory" do
      @generator.factory_with_attributes.should == expected
    end

    it "adds the to_factory method to an active record object" do
      ActiveRecord::Base.send :include, ToFactory
      user.to_factory.should == expected
    end

    it "raises an error if you try to inlude in a non ActiveRecord object" do
      class Egg;end

      lambda{Egg.send :include, ToFactory}.should raise_error ToFactory::MustBeActiveRecordSubClassException
    end
  end

end
