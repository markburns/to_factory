describe ToFactory do
  let!(:user)    { ToFactory::User   .create :name => "Jeff",       :email => "test@example.com", :some_id => 8}
  let!(:project) { ToFactory::Project.create :name => "My Project", :objective => "easy testing", :some_id => 9 }

  before { FileUtils.rm_rf "./tmp/factories" }

  def user_file
    File.read("./tmp/factories/to_factory/user.rb") rescue nil
  end

  def project_file
    File.read("./tmp/factories/to_factory/project.rb") rescue nil
  end

  describe ".generate!" do
    it "generates all factories" do
      ToFactory.generate!
      expect(user_file)   .to eq ToFactory(ToFactory::User.   first)
      expect(project_file).to eq ToFactory(ToFactory::Project.first)
    end
  end

  describe "Object#ToFactory" do
    def user_file_includes(content)
      expect(user_file).to include content
    end

    context "with no existing file" do
      it "creates the file" do
        expect(user_file).to be_nil
        ToFactory(:items => user)
        expect(user_file).to be_present
      end

      context "with single ActiveRecord::Base instance argument" do
        it "creates the file" do
          expect(user_file).to be_nil
          ToFactory(user)
          expect(user_file).to be_present
        end
      end
    end

    context "with an existing file" do
      before do
        expect(user_file).to be_nil
        ToFactory.generate!
        expect(user_file).to be_present
      end

      context "with a name for the factory" do
        it "appends to the file" do
          user_file_includes('factory(:"to_factory/user"')
          ToFactory(:items => {:specific_user => user})
          user_file_includes('factory(:"specific_user", :parent => :"to_factory/user"')
        end
      end

      it "without a name" do
        expect(lambda{ToFactory(:items => user)}).
          to raise_error ToFactory::AlreadyExists
      end

      context "with autosave: false" do
        it "outputs to stdout"
      end
    end
  end
end
