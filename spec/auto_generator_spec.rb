describe ToFactory::AutoGenerator do
  let(:generator) { ToFactory::AutoGenerator.new(model_finder, file_writer) }
  let(:model_finder) { double("model finder") }
  let(:file_writer) { double("file writer" ) }

  describe "#all!" do
    context "no args" do
      let(:user_klass){ double("UserKlass", :name => "User") }
      let!(:user)  {
        user = double("user", :class => user_klass, :attributes => {:name => "Mark", :email => "mark@example.com"})
        expect(user_klass).to receive(:first).and_return user
        user
      }

      let(:project_klass)  { double("ProjectKlass", :name => "Project" ) }

      let!(:project)  {
        project = double("project", :class => project_klass, :attributes => {:title => "To Factory", :objective => "easy testing"})
        expect(project_klass).to receive(:first).and_return project
        project
      }


      it "adds factories for all models" do
        expect(model_finder).to receive(:all)       .and_return [user_klass, project_klass]
        expect(user)   .to      receive(:to_factory).and_return "factory a"
        expect(project).to      receive(:to_factory).and_return "factory b"

        expect(file_writer).to receive(:write).
          with({:user => "factory a", :project =>"factory b"})

        generator.all!
      end
    end
  end
end

describe ToFactory::ModelFinder do
  let(:finder) { ToFactory::ModelFinder.new(path) }
  let(:path) { "spec/support" }

  describe "#all" do
    context "no match"do
      let(:path) { "tmp/doesnt_exist" }
      it do
        expect(finder.all).to eq []
      end
    end

    context "no args" do
      it "adds factories for all models" do
        expect(finder.all).to eq [ToFactory::User, ToFactory::Project]
      end
    end
  end

end

describe ToFactory::FileWriter do
  before do
    FileUtils.rm_rf "tmp/factories/**"
  end

  let(:finder) { ToFactory::FileWriter.new("tmp/factories") }

  describe "#write" do
    it "adds factories for all models" do
      finder.write({:user => "factory a", :project =>"factory b"})
      expect(File.readlines("tmp/factories/user.rb")).to eq ["factory a"]
      expect(File.readlines("tmp/factories/project.rb")).to eq ["factory b"]
    end
  end

end
