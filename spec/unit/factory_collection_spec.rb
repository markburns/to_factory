describe ToFactory::FactoryCollection do
  let(:user) { double "user" }
  let(:admin) { double "admin" }
  let(:file_writer) { double("file_writer") }

  let(:collection) do
    ToFactory::FactoryCollection.new(:user => user, :admin => admin)
  end

  describe "#add" do
    it "checks for existence" do
      expect(lambda{collection.add(:user, user)}).
        to raise_error ToFactory::AlreadyExists
    end
  end

  describe "#read" do
    let(:file_system) { double ToFactory::FileSystem }

    it "appends entries from the file system" do
      expect(file_system).to receive(:read).and_return :a => 1, :b => 2
      collection.read(file_system)

      expect(collection.items.keys).to match_array [:user, :admin, :a, :b]
    end

    it "detects clashes" do
      expect(file_system).to receive(:read).and_return :user => "user"
      expect(lambda{collection.read(file_system)}).
        to raise_error ToFactory::AlreadyExists
    end
  end
end
