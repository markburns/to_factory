describe ToFactory::FileSync do
  describe "#all!" do
    let!(:user   ) { double("user",    :is_a? => true, :class => double(:name => "User")) }
    let!(:project) { double("project", :is_a? => true, :class => double(:name => "Project")) }
    let(:file_system  ) { double("file file_system" ) }
    let(:finder) { double("model finder") }
    let(:factories) { {:user => "factory a", :project => "factory b"} }

    context "with a finder and a file system" do
      let(:sync) { ToFactory::FileSync.new(finder, file_system) }

      before do
        x(finder,      :all             ).r [user, project]
        x(file_system, :write, factories)
        x(sync,        :ToFactory       ).r("factory a", "factory b")
      end

      it "requests instances from the model finder and writes to the file file_system" do
        sync.perform
      end
    end
  end
end
