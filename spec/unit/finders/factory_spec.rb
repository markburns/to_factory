describe ToFactory::Finders::Factory do
  describe "#call" do
    before do
      FileUtils.mkdir_p "./tmp/factories/to_factory"
      FileUtils.cp "./spec/example_factories/user_admin_with_header.rb",
        "./tmp/factories/to_factory/user.rb"
    end

    let(:user_file_contents) { File.read "./spec/example_factories/user.rb"}
    let(:admin_file_contents){ File.read "./spec/example_factories/admin.rb" }

    it "reads all the factories" do
      finder = ToFactory::Finders::Factory.new

      result = finder.call

      expect(result[0].definition).
        to match_sexp user_file_contents

      expect(result[1].definition).
        to match_sexp admin_file_contents
    end
  end

end

