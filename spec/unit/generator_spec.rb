describe ToFactory::Generator do
  before(:each) do
    ToFactory::User.destroy_all
    ActiveRecord::Base.connection.execute "delete from sqlite_sequence where name = 'users'"
  end

  let(:birthday) do
    Time.zone = "UTC"
    Time.zone.parse("2014-07-08T22:30+09:00") 
  end

  let!(:user) { ToFactory::User.create :name => "Jeff", :email => "test@example.com", :some_id => 8, :birthday => birthday}
  let(:generator) { ToFactory::Generator.new user }

  describe ".new" do
    it "requires an activerecord instance" do
      expect(lambda{ToFactory::Generator.new ""}).to raise_error ToFactory::MissingActiveRecordInstanceException
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


  describe "#header" do
    it do
      expect(generator.header).to eq  <<-eof.strip_heredoc
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
    it "generates usable datetime strings" do
      output = generator.factory_attribute(:birthday, birthday)
      expect(output).to eq '    birthday "2014-07-08T13:30Z"'
    end
  end

  describe "#ToFactory" do
    let(:expected) do
      <<-eof.strip_heredoc
        FactoryGirl.define do
          factory(:"to_factory/user") do
            birthday "2014-07-08T13:30Z"
            email "test@example.com"
            name "Jeff"
            some_id 8
          end
        end
      eof
    end

    it do
      expect(generator.to_factory).to eq expected
      expect(ToFactory user     ).to eq expected
    end
  end
end
