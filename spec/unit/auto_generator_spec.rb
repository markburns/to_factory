describe ToFactory::AutoGenerator do
  describe "#all!" do
    let!(:user   ) { double("user",    :class => double(:name => "User"),    :to_factory => "factory a") }
    let!(:project) { double("project", :class => double(:name => "Project"), :to_factory => "factory b") }
    let(:writer) { double("file writer" ) }

    context "with a finder and a writer" do
      let(:finder) { double("model finder") }
      let(:generator) { ToFactory::AutoGenerator.new(finder, writer) }
      it "requests instances from the model finder and writes to the file writer" do
        expect(finder).to receive(:all).
          and_return [user, project]

        expect(writer).
          to receive(:write).
          with({:user => "factory a", :project =>"factory b"})

        generator.all!
      end
    end

    context "with path arguments" do
      let(:finder) { double("finder", :all => [user, project])}

      before do
        expect(ToFactory::ModelFinder).to receive(:new).with("a").and_return finder
        expect(ToFactory::FileWriter ).to receive(:new).with("b").and_return writer
      end
      it do
        generator = ToFactory::AutoGenerator.new("a", "b")
        expect(writer).to receive(:write).with({:user => "factory a", :project => "factory b"})
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
