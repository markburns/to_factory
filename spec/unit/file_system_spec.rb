describe ToFactory::FileSystem do
  before do
    FileUtils.rm_rf("tmp/factories/**")
  end

  let(:fs) { ToFactory::FileSystem.new("tmp/factories") }

  describe "#write" do
    it "adds factories for all models" do
      fs.write({:user => "factory a", :project =>"factory b"})
      expect(File.read("tmp/factories/user.rb")).to eq "factory a"
      expect(File.read("tmp/factories/project.rb")).to eq "factory b"
    end
  end


end
