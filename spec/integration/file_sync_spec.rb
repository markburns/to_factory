describe "FileSync" do
  let(:user) { create_user!  }
  let(:admin) { create_admin!  }
  let(:project) { create_project!  }
  let(:version) { ToFactory.new_syntax? ? "new" : "old"}
  let(:expected_user_file)             { File.read("./spec/example_factories/#{version}_syntax/user.rb") }
  let(:expected_user_with_header_file) { File.read("./spec/example_factories/#{version}_syntax/user_with_header.rb") }
  let(:expected_admin_file)            { File.read("./spec/example_factories/#{version}_syntax/admin.rb") }
  let(:user_with_header)               { File.read("./spec/example_factories/#{version}_syntax/user_with_header.rb") }
  let(:user_admin_with_header)         { File.read("./spec/example_factories/#{version}_syntax/user_admin_with_header.rb") }


  before do
    FileUtils.rm_rf "./tmp/factories"
  end

  def user_file
    File.read("./tmp/factories/to_factory/user.rb") rescue nil
  end

  def project_file
    File.read("./tmp/factories/to_factory/project.rb") rescue nil
  end


  context "with no arguments" do
    before do
      user
      admin
    end

    it "finds the first existing instance" do
      sync = ToFactory::FileSync.new
      sync.perform

      expect(user_file ).to match_sexp expected_user_with_header_file
    end
  end

  context "with an instance" do
    it "writes that instance" do
      sync = ToFactory::FileSync.new(user)
      sync.perform

      expect(user_file   ).to match_sexp user_with_header
      expect(project_file).to eq nil
    end
  end



  context "with a pre-existing file" do
    let(:sync) { ToFactory::FileSync.new(user) }
    before do
      sync.perform
      expect(user_file).to match_sexp user_with_header
    end

    it "raises an error" do
      expect(lambda{ sync.perform }).to raise_error ToFactory::AlreadyExists
    end

    context "with a named factory" do
      it do
        sync = ToFactory::FileSync.new({:admin => admin})
        sync.perform

        parser = ToFactory::Parsing::File.new(user_file)
        result = parser.parse[ToFactory::User]
        expect(result[:admin]).to match_sexp expected_admin_file
        expect(result[:"to_factory/user"]).to match_sexp expected_user_file

        expect(lambda{
          sync.perform
        }).to raise_error ToFactory::AlreadyExists
      end
    end
  end
end
