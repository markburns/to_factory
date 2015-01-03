describe ToFactory::FactoryCollection do
  let(:user_klass) { double "user klass", :name => "ToFactory::User"}
  let(:user) { double "user" }
  let(:admin) { double "admin" }
  let(:file_writer) { double("file_writer") }

  let(:collection) do
    ToFactory::FactoryCollection.new(user_klass =>
                                     {:user => user, :admin => admin})
  end

  describe "#add" do
    it "checks for existence" do
      expect(lambda{collection.add(user_klass, :user, user)}).
        to raise_error ToFactory::AlreadyExists
    end
  end

  describe "#read" do
    let(:file_system) { double ToFactory::FileSystem }

    it "appends entries from the file system" do
      expect(file_system).to receive(:read).and_return :a => {}, :b => {}
      collection.read_from_file_system(file_system)

      expect(collection.items.keys.length).to eq 3
      expect(collection.items.keys).to include :a
      expect(collection.items.keys).to include :b
      expect(collection.items.keys).to include user_klass
    end

    it "detects clashes" do
      expect(file_system).to receive(:read).and_return user_klass => {:user =>"clashes"}
      expect(lambda{collection.read_from_file_system(file_system)}).
        to raise_error ToFactory::AlreadyExists
    end
  end
end
