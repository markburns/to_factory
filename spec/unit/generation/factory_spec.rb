describe ToFactory::Generation::Factory do
  before(:each) do
    ToFactory::User.destroy_all
    ActiveRecord::Base.connection.execute "delete from sqlite_sequence where name = 'users'"
  end

  let(:birthday) do
    Time.find_zone("UTC").parse("2014-07-08T15:30 UTC")
  end

  let!(:user) { create_user! }

  let(:representation) { ToFactory::Representation.from(user) }
  let(:generator) { ToFactory::Generation::Factory.new representation  }



  describe "#header" do
    it do
      if ToFactory.new_syntax?
        expect(generator.header{}).to match_sexp  <<-eof.strip_heredoc
          factory(:"to_factory/user") do
          end
        eof
      else
        expect(generator.header{}).to match_sexp  <<-eof.strip_heredoc
          Factory.define(:"to_factory/user") do |o|
          end
        eof
      end
    end
  end

  describe "#attributes" do
    let(:representation) do
      double(:attributes => {"something" => "something",
                             :id         => 123,
                             :created_at => anything,
                             :created_on => anything,
                             :updated_at => anything,
                             :updated_on => anything,
                             nil => nil})
    end
    it "ignores blank keys, :id, :created_at, :updated_at, :created_on, :updated_on" do
      expect(generator.attributes).to eq({"something" => "something"})
    end
  end
  describe "#factory_attribute" do
    it do
      if ToFactory.new_syntax?
        expect(generator.factory_attribute(:name, nil))   .to eq '    name nil'
        expect(generator.factory_attribute(:name, "Jeff")).to eq '    name "Jeff"'
        expect(generator.factory_attribute(:id, 8))       .to eq '    id 8'

      else
        expect(generator.factory_attribute(:name, nil))   .to eq '  o.name nil'
        expect(generator.factory_attribute(:name, "Jeff")).to eq '  o.name "Jeff"'
        expect(generator.factory_attribute(:id, 8))       .to eq '  o.id 8'
      end
    end
    it "generates usable datetime strings" do
      output = generator.factory_attribute(:birthday, birthday)
      if ToFactory.new_syntax?
        expect(output).to eq '    birthday "2014-07-08T15:30 UTC"'
      else
        expect(output).to eq '  o.birthday "2014-07-08T15:30 UTC"'
      end
    end
  end

  describe "#ToFactory" do
    let(:expected) do
      File.read "./spec/example_factories/#{version}_syntax/user.rb"
    end

    it do
      expect(generator.to_factory).to match_sexp expected
      result = ToFactory(user).values.first.first
      expect(result.definition).to match_sexp expected
    end
  end
end
