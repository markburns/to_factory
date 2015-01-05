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
end

