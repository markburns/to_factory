describe ToFactory::Generator do
  before(:each) do
    ToFactory::User.destroy_all
    ActiveRecord::Base.connection.execute "delete from sqlite_sequence where name = 'users'"
  end
  let!(:user) { ToFactory::User.create :name => "Jeff", :email => "test@example.com", :some_id => 8 }
  let(:generator) { ToFactory::Generator.new user }

  describe ".new" do
    it "requires an activerecord instance" do
      expect(lambda{ToFactory::Generator.new ""}).to raise_error ToFactory::MissingActiveRecordInstanceException
    end

    it "raises an error if you try to inlude in a non ActiveRecord object" do
      class Cheese;end
      expect(lambda{Cheese.send :include, ToFactory}).to raise_error ToFactory::MustBeActiveRecordSubClassException
    end
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


  describe "#factory" do
    it do
      expect(generator.factory).to eq  <<-eof.strip_heredoc
        FactoryGirl.define do
          factory(:"to_factory/user") do
          end
        end
      eof
    end
  end

  describe "#factory_attribute" do
    it do
      expect(generator.factory_attribute(:name, nil))   .to eq '    name nil'
      expect(generator.factory_attribute(:name, "Jeff")).to eq '    name "Jeff"'
      expect(generator.factory_attribute(:id, 8))       .to eq '    id 8'
    end
  end

  describe "#factory_with_attributes" do
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

    it do
      expect(generator.factory_with_attributes).to eq expected
    end

    it do
      expect(user.to_factory).to eq expected
    end
  end
end
