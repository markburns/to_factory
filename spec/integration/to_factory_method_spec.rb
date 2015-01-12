describe ToFactory do
  let!(:user)    { create_user! }
  let!(:project) { create_project!}

  before { FileUtils.rm_rf "./tmp/factories" }

  def user_file
    File.read("./tmp/factories/to_factory/user.rb") rescue nil
  end

  def project_file
    File.read("./tmp/factories/to_factory/project.rb") rescue nil
  end

  let(:expected_user_file) { File.read "./spec/example_factories/#{version}_syntax/user_with_header.rb"}
  let(:expected_project_file) { File.read "./spec/example_factories/#{version}_syntax/project_with_header.rb"}

  describe "ToFactory.definitions" do
    it do
      ToFactory()
      expect(ToFactory.definitions).to match_array ["to_factory/user", "to_factory/project"]
    end

  end

  describe "ToFactory.definition_for" do
    it do
      expect(ToFactory.definition_for user).to match_sexp expected_user_file
    end

    it do
      ToFactory(user)
      expect(ToFactory.definition_for :"to_factory/user").to match_sexp expected_user_file
    end

    it "raises a not found error" do
      expect(lambda{ToFactory.definition_for :"to_factory/user"}).to raise_error ToFactory::NotFoundError
    end
  end

  describe "Object#ToFactory" do
    context "with multiple levels of parent classes" do
      let(:filename) { "spec/example_factories/#{version}_syntax/#{'user_admin_super_admin'}.rb"}

      it "gets the output order correct" do
        output = "./tmp/factories/to_factory/user.rb"
        `mkdir -p ./tmp/factories/to_factory`
        `cp #{filename} #{output}`

        ToFactory(:root => user)

        expected = File.read "spec/example_factories/#{version}_syntax/#{'user_admin_root'}.rb"

        #user, admin, super_admin, root
        expect(File.read(output)).to match_sexp expected
      end
    end

    it "generates all factories" do
      ToFactory()
      #simple check for equivalent ruby
      expect(user_file)   .to match_sexp expected_user_file
      expect(project_file).to match_sexp expected_project_file

      #once we are sure output is equivalent ruby, check output is identical
      expect(user_file.chomp)   .to eq expected_user_file.chomp
      expect(project_file.chomp).to eq expected_project_file.chomp
    end

    def user_file_includes(content)
      expect(user_file).to include content
    end

    context "excluding classes" do
      before do
        user
        project
      end

      it "ignores specified classes" do
        ToFactory(:exclude => ToFactory::User)
        expect(user_file).to be_nil
        expect(project_file).to be_present
      end

      it "ignores specified classes - sanity check" do
        ToFactory(:exclude => ToFactory::Project)
        expect(user_file).to be_present
        expect(project_file).to be_nil
      end
    end

    context "with no existing file" do
      it "creates the file" do
        expect(user_file).to be_nil
        ToFactory(user)
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
        ToFactory(user)
        expect(user_file).to be_present
      end

      context "with a name for the factory" do
        it "appends to the file" do
          if ToFactory.new_syntax?
            user_file_includes('factory(:"to_factory/user"')
          else
            user_file_includes('Factory.define(:"to_factory/user"')
          end

          ToFactory(:specific_user => user)
          if ToFactory.new_syntax?
            user_file_includes('factory(:specific_user, :parent => :"to_factory/user"')
          else
            user_file_includes('Factory.define(:specific_user, :parent => :"to_factory/user"')
          end


        end
      end

      it "without a name" do
        expect(lambda{ToFactory(user)}).
               to raise_error ToFactory::AlreadyExists
      end
    end
  end
end
