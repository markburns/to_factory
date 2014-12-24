describe ToFactory::AutoGenerator do
  describe "#all!" do
    let!(:user   ) { double("user",    :is_a? => true, :class => double(:name => "User")) }
    let!(:project) { double("project", :is_a? => true, :class => double(:name => "Project")) }
    let(:writer  ) { double("file writer" ) }
    let(:finder) { double("model finder") }

    context "with a finder and a writer" do
      let(:generator) { ToFactory::AutoGenerator.new(finder, writer) }

      before do
        x(finder, :all).r [user, project]
        x(writer, :write, {:user => "factory a", :project => "factory b"})
        x(generator,              :ToFactory          ).r("factory a", "factory b")
      end

      it "requests instances from the model finder and writes to the file writer" do
        generator.all!
      end
    end


    context "with path arguments" do
      let(:models_path) { "a" }
      let(:factories_path) { "b" }
      let(:generator) do
        ToFactory::AutoGenerator.new(models_path, factories_path)
      end

      before do
        x(finder, :all).r [user, project]
        x(writer, :write, {:user => "factory a", :project => "factory b"})
      end

      it "instantiates a finder and writer with the passed path arguments" do
        x(ToFactory::ModelFinder, :new, models_path   ).r finder
        x(ToFactory::FileWriter,  :new, factories_path).r writer
        x(generator,              :ToFactory          ).r("factory a", "factory b")
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
        expect(finder.all).to match_array [ToFactory::User, ToFactory::Project]
      end
    end
  end

end

describe ToFactory::FileWriter do
  before do
    FileUtils.rm_rf("tmp/factories/**")
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
