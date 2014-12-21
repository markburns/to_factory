describe ToFactory::Generator do
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
      expect(@generator.model_class).to eq User
    end

    let(:user_factory_1) do
      user_factory_1 = <<-eof
FactoryGirl.define do
  factory(:user) do
    email "blah@example.com"
    name "Tom"
    some_id 7
  end
end
      eof
      user_factory_1.chop
    end
    let(:user_factory_2) do
      user_factory_2 = <<-eof
FactoryGirl.define do
  factory(:user) do
    email "james@example.com"
    name "James"
    some_id 8
  end
end
      eof
      user_factory_2.chop
    end
    context "looking up attributes" do
      it "takes a key value for id" do
        result = @generator.factory_for :id => 1
        expect(result).to eq user_factory_1
      end

      it "takes an integer for id" do
        result = @generator.factory_for 1
        expect(result).to eq user_factory_1
      end

      it "takes a key value and does a lookup" do
        result = @generator.factory_for :name => 'Tom'
        expect(result).to eq user_factory_1

        result = @generator.factory_for :name => 'James'
        expect(result).to eq user_factory_2
      end

      it "takes multiple keys and does a lookup" do
        result = @generator.factory_for :id => 1, :name => 'Tom'
        expect(result).to eq user_factory_1

        result = @generator.factory_for :id => 1, :name => 'Incorrect'
        expect(result).to be_nil
      end

      context "with invalid attributes" do
        it "raises an exception" do
          expect(lambda{@generator.factory_for :id => 1000}).to raise_error ActiveRecord::RecordNotFound
        end
      end
    end
  end

  it "initializes with an activerecord instance" do
    user = User.create :name => "Jeff"
    @generator = ToFactory::Generator.new user
    expect(@generator.model_class).to eq "User"
  end

  it "initializes without an object" do
    @generator = ToFactory::Generator.new
    expect(@generator.model_class).to be_nil
  end

  it "generates the first line of the factory" do
    @generator = ToFactory::Generator.new User
    f = @generator.factory
    user = User.create :name => "Jeff"
    output = <<-eof
FactoryGirl.define do
  factory(:user) do
  end
end
    eof
    expect(f).to eq  output.chop
  end


  it "raises an exception without an AR object, when requesting attributes" do
    @generator = ToFactory::Generator.new User
    expect(lambda{@generator.factory_attribute :foo}).to raise_error ToFactory::MissingActiveRecordInstanceException
  end

    context "with a user in the database" do
    before do
      User.create :name => "Jeff", :email => "test@example.com", :some_id => 8
      @generator = ToFactory::Generator.new user
    end

    let(:user){ User.first}

    it "generates lines for multiple the attributes" do
      expect(@generator.factory_attribute(:name)).to eq '    name "Jeff"'
      expect(@generator.factory_attribute(:email)).to eq '    email "test@example.com"'
    end

    let(:expected) do
      expected = <<-eof
FactoryGirl.define do
  factory(:user) do
    email "test@example.com"
    name "Jeff"
    some_id 8
  end
end
      eof
      expected.chop
    end

    it "generates the full factory" do
      expect(@generator.factory_with_attributes).to eq expected
    end

    it "adds the to_factory method to an active record object" do
      ActiveRecord::Base.send :include, ToFactory
      expect(user.to_factory).to eq expected
    end

    it "raises an error if you try to inlude in a non ActiveRecord object" do
      class Egg;end

      expect(lambda{Egg.send :include, ToFactory}).to raise_error ToFactory::MustBeActiveRecordSubClassException
    end
  end

end
