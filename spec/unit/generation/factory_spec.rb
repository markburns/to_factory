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
  let(:generator) { ToFactory::Generation::Factory.new representation }

  describe "#name" do
    context "with a simple name" do
      let(:representation) { double "Representation", name: "some_name" }

      it "adds just displays the name" do
        expect(generator.name).to eq "some_name"
      end
    end

    context "with a namespace" do
      let(:representation) { double "Representation", name: "some_namespace/some_name" }

      it "adds quotes to the name" do
        expect(generator.name).to eq "some_namespace/some_name".inspect
      end
    end

    context "with a an already quoted name in a namespace" do
      let(:representation) { double "Representation", name: "some_namespace/some_name".inspect }

      it "doesn't add extra adds quotes to the name" do
        expect(generator.name).to eq "some_namespace/some_name".inspect
      end
    end
  end

  describe "#header" do
    it do
      expect(generator.header {}).to match_sexp <<-eof.strip_heredoc
        factory(:"to_factory/user") do
        end
      eof
    end
  end

  describe "#attributes" do
    let(:representation) do
      double(attributes: { "something" => "something",
                           :id         => 123,
                           :created_at => anything,
                           :created_on => anything,
                           :updated_at => anything,
                           :updated_on => anything,
                           nil => nil })
    end
    it "ignores blank keys, :id, :created_at, :updated_at, :created_on, :updated_on" do
      expect(generator.attributes).to eq("something" => "something")
    end
  end
  describe "#factory_attribute" do
    it do
      expect(generator.factory_attribute(:name, nil))   .to eq "    name { nil }"
      expect(generator.factory_attribute(:name, "Jeff")).to eq '    name { "Jeff" }'
      expect(generator.factory_attribute(:id, 8))       .to eq "    id { 8 }"
    end
    it "generates usable datetime strings" do
      output = generator.factory_attribute(:birthday, birthday)
      expect(output).to eq '    birthday { "2014-07-08T15:30 UTC" }'
    end
  end

  describe "#ToFactory" do
    let(:expected) do
      File.read "./spec/example_factories/user.rb"
    end

    it do
      expect(generator.to_factory).to match_sexp expected
      result = ToFactory(user).values.first.first
      expect(result.definition).to match_sexp expected
    end
  end
end
