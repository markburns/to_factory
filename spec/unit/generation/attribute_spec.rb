describe ToFactory::Generation::Attribute do
  let(:attribute) { ToFactory::Generation::Attribute.new(:some_attributes, {:a => 1}) }

  describe "#to_s" do
    it do
      expect(attribute.to_s).to include "some_attributes({:a => 1})"
    end
  end

  describe "#inspect_value" do
    it do
      expect(attribute.inspect_value({:a => 1})).to eq "({:a => 1})"
    end

    it do
      hash = ActiveSupport::OrderedHash.new
      hash[{"with" => :hash}] = "keys"
      hash[2] = "integers"
      hash[:a] = {:nested => "hash"}

      expected = '({{"with" => :hash} => "keys", 2 => "integers", :a => {:nested => "hash"}})'

      expect(attribute.inspect_value(hash)).to eq expected
    end
  end

end
