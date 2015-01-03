describe ToFactory::FileSystem do
  let(:fs) { ToFactory::FileSystem.new }
  let(:user_file_contents)    { File.read "./spec/example_factories/new_syntax/user.rb"}
  let!(:user) do
    ToFactory::User.create(
      {
        :name     => " a user name",
        :birthday => "2014-07-08T13:30Z",
        :email    => "test@example.com",
        :name     => "Jeff",
        :some_id  => 8
      }
    )
  end

  describe "#read" do
    before do
      instance = ToFactory::FileWriter.new
      instance.all!
    end

    it "reads all the factories" do
      result = fs.read
      expect(result[:"to_factory/user"]).
        to match_sexp user_file_contents
    end
  end

end
