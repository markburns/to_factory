describe ToFactory do
  let(:user)    { ToFactory::User   .create :name => "Jeff",       :email => "test@example.com", :some_id => 8}
  let(:project) { ToFactory::Project.create :name => "My Project", :objective => "easy testing", :some_id => 9 }

  before do
    FileUtils.rm_rf "./tmp/factories"
  end

  let(:user_file) do
    File.read("./tmp/factories/to_factory/user.rb") rescue nil
  end

  let(:project_file) do
    File.read("./tmp/factories/to_factory/project.rb") rescue nil
  end


  describe ".generate!" do
    before do
      user
      project
    end

    it "generates all factories" do
      ToFactory.generate!(:models => "spec/support", :factories => "tmp/factories")
      expect(user_file)   .to eq ToFactory(ToFactory::User.   first)
      expect(project_file).to eq ToFactory(ToFactory::Project.first)
    end
  end

  describe "Object#ToFactory" do
    def user_file_includes(content)
      expect(user_file).to include content
    end

    context "with no existing file" do
      it "create to the file" do
        expect(user_file).to be_nil
        ToFactory(:items => user, :factories => "tmp/factories")
        expect(user_file).to be_present
      end
    end

    context "with an existing file" do
      before do
        expect(user_file).to be_nil
        ToFactory.generate!(:models => "spec/support", :factories => "tmp/factories")
        expect(user_file).to be_present
      end

      context "with a name for the factory" do
        it "appends to the file" do
          user_file_includes("factory :user")
          ToFactory(:items => {:specific_user => user}, :factories => "tmp/factories")
          user_file_includes("factory :specific_user, :parent => :user")
        end
      end

      it "without a name" do
        expect(lambda{ToFactory(:items => user, :factories => "tmp/factories")}).
          to raise_error ToFactory::AlreadyExists
      end

      context "with autosave: false" do
        it "outputs to stdout"
      end
    end
  end
end
