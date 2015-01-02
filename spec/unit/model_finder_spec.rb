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
    context "with a match" do
      let(:path) { "spec/support" }
      it do
        expect(finder.all).to match_array [ToFactory::User, ToFactory::Project]
      end
    end

    context "no args" do
      it "adds factories for all models" do
        expect(finder.all).to match_array [ToFactory::User, ToFactory::Project]
      end
    end
  end

end


