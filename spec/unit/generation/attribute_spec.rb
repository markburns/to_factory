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
      value = ActiveSupport::OrderedHash.new(
                   {{"with" => :hash} => "keys", 2 => "integers", :a => {:nested => "hash"}}
      )

      expected = '({{"with" => :hash} => "keys", 2 => "integers", :a => {:nested => "hash"}})'

      expect(attribute.inspect_value(value)).to eq expected
    end
  end

end
