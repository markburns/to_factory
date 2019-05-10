describe ToFactory::FileWriter do
  let(:fw) { ToFactory::FileWriter.new }

  describe "#write" do
    def user_file
      File.read("tmp/factories/to_factory/user.rb")
    end

    def project_file
      File.read("tmp/factories/to_factory/project.rb")
    end

    it "adds factories for all models" do
      user_representation = double :name => :user, "definition" => "factory a"
      project_representation = double name: "project", definition: "factory b"
      fw.write("to_factory/user" => [user_representation],
               "to_factory/project" => [project_representation])

      expect(user_file).to match /FactoryBot.define do/
      expect(user_file).to include "factory a"
      expect(project_file).to include "factory b"
    end
  end
end
