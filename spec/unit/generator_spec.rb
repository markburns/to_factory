describe ToFactory::Generator do
  before(:each) do
    ToFactory::User.destroy_all
    ActiveRecord::Base.connection.execute "delete from sqlite_sequence where name = 'users'"
  end

  it "requires an activerecord instance" do
    expect(lambda{ToFactory::Generator.new ""}).to raise_error ToFactory::MissingActiveRecordInstanceException
  end

  describe "#name" do
    it "handles namespacing" do
      generator = ToFactory::Generator.new(ToFactory::Project.new)
      expect(generator.name).to eq "\"to_factory/project\""
    end

    it do
      class NotNamespacedActiveRecordClassButLongEnoughItShouldntCauseConflicts < ActiveRecord::Base; end
      instance = NotNamespacedActiveRecordClassButLongEnoughItShouldntCauseConflicts.new
      generator = ToFactory::Generator.new(instance)
      expect(generator.name).to eq "not_namespaced_active_record_class_but_long_enough_it_shouldnt_cause_conflicts"
    end
  end

  it "generates the first line of the factory" do
    user = ToFactory::User.create :name => "Jeff"
    @generator = ToFactory::Generator.new user

    expect(@generator.factory).to eq  <<-eof.strip_heredoc
      FactoryGirl.define do
        factory(:"to_factory/user") do
        end
      end
    eof

  end

    context "with a user in the database" do
    before do
      ToFactory::User.create :name => "Jeff", :email => "test@example.com", :some_id => 8
      @generator = ToFactory::Generator.new user
    end

    let(:user){ ToFactory::User.first}

    it "generates lines for multiple the attributes" do
      expect(@generator.factory_attribute(:name)).to eq '    name "Jeff"'
      expect(@generator.factory_attribute(:email)).to eq '    email "test@example.com"'
    end

    let(:expected) do
      <<-eof.strip_heredoc
        FactoryGirl.define do
          factory(:"to_factory/user") do
            email "test@example.com"
            name "Jeff"
            some_id 8
          end
        end
      eof
    end

    it "generates the full factory" do
      expect(@generator.factory_with_attributes).to eq expected
    end

    it "adds the to_factory method to an active record object" do
      expect(user.to_factory).to eq expected
    end

    it "raises an error if you try to inlude in a non ActiveRecord object" do
      class Cheese;end

      expect(lambda{Cheese.send :include, ToFactory}).to raise_error ToFactory::MustBeActiveRecordSubClassException
    end
  end

end
