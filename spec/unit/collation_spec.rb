describe ToFactory::Collation do
  def perform
    ToFactory::Collation.merge(a, b)
  end

  context "matching keys" do
    let(:a) { {:A => {:a => 1}} }
    let(:b) { {:B => {:a => 2}} }

    it do
      expect(lambda{perform}).to raise_error ToFactory::AlreadyExists
    end
  end

  context "non matching keys" do
    let(:a) { {:A => {:a => 1}} }
    let(:b) { {:B => {:b => 2}} }

    it do
      result = {:A => {:a  => 1}, :B => {:b => 2}}.with_indifferent_access
      expect(perform).to eq result
    end
  end

  context "merging" do
    let(:a) { {:A => {:a => 1}} }
    let(:b) { {:A => {:b => 2}} }

    it do
      result = {:A => {:a  => 1, :b => 2}}.with_indifferent_access
      expect(perform).to eq result
    end
  end
  context "organizing" do
    it do
      new_definitions = {ToFactory::User=>{:root=>"  Factory.define(:root, :parent => :\"to_factory/user\") do|o|\n  o.birthday \"2014-07-08T15:30Z\"\n  o.email \"test@example.com\"\n  o.name \"Jeff\"\n  o.some_id 8\n  end\n"}}
      pre_existing    = {ToFactory::User=>{"to_factory/user"=>"Factory.define(:\"to_factory/user\") { |o| o.name(\"User\") }", "admin"=>"Factory.define(:admin, :parent => :\"to_factory/user\") { |o| o.name(\"Admin\") }", "super_admin"=>"Factory.define(:super_admin, :parent => :admin) { |o| o.name(\"Super Admin\") }"}}

      result = ToFactory::Collation.organize(new_definitions, pre_existing)
    end
  end
end

