describe ToFactory::Collation do
  describe "detect_collisions!" do
    let(:collation) { ToFactory::Collation.new(a, b) }
    let(:a) { [double(name: "a")] }
    let(:b) { [double(name: "a")] }

    def perform
      collation.detect_collisions!(a, b)
    end

    it do
      expect(-> { perform }).to raise_error ToFactory::AlreadyExists
    end

    context "non matching keys" do
      let(:a) { [double(name: "a")] }
      let(:b) { [double(name: "b")] }

      it do
        expect(perform).to eq nil
      end
    end
  end

  context "organizing" do
    let(:root) { ToFactory::Representation.new(:root, "super_admin", "  Factory.define(:root, :parent => :\"to_factory/user\") do|o|\n  o.birthday \"2014-07-08T15:30Z\"\n  o.email \"test@example.com\"\n  o.name \"Jeff\"\n  o.some_id 8\n  end\n") }
    let(:user) { ToFactory::Representation.new("to_factory/user", nil, "Factory.define(:\"to_factory/user\") { |o| o.name(\"User\") }") }
    let(:admin) { ToFactory::Representation.new("admin", "to_factory/user", "Factory.define(:admin, :parent => :\"to_factory/user\") { |o| o.name(\"Admin\") }") }
    let(:super_admin) { ToFactory::Representation.new("super_admin", "admin", "Factory.define(:super_admin, :parent => :admin) { |o| o.name(\"Super Admin\") }") }

    it do
      new_definitions = [root]
      pre_existing    = [admin, user, super_admin]

      result = ToFactory::Collation.organize(new_definitions, pre_existing)
      result = result["to_factory/user"]
      expect(result.map &:hierarchy_order).to eq [1, 2, 3, 4]
      expect(result).to eq [user, admin, super_admin, root]
    end
  end
end
