describe ToFactory::Parsing::File do
  let(:user_contents) { File.read "spec/example_factories/user.rb" }
  let(:admin_contents) { File.read "spec/example_factories/admin.rb"}

  let(:parser) { ToFactory::Parsing::File.from_file(filename) }

  describe "#multiple_factories? and #header?" do
    context "new syntax" do
      tests =   #file,                      multiple, header
                [
                  ["user",                   false,   false],
                  ["user_with_header",       false,   true],
                  ["user_admin",             true,    false],
                  ["user_admin_with_header", true,    true]
                ]

      tests.each do |file, multiple, header|
        context "with #{header ? 'header' : 'no header'} and #{multiple ? 'multiple factories' : 'one factory'}" do
          context "file: #{file}" do
            let(:filename) { "spec/example_factories/#{file}.rb"}

            it { expect(parser.multiple_factories?).to eq multiple }
            it { expect(parser.header?).to eq header }
          end
        end
      end
    end
  end

  describe "#parse" do
    context "with multiple levels of parent classes" do
      let(:filename) { "spec/example_factories/#{'user_admin_super_admin'}.rb"}

      it do
        result = parser.parse

        expect(result.map(&:name)).to match_array ["super_admin", "admin", "to_factory/user"]
      end
    end

    context "file: user" do
      let(:filename) { "spec/example_factories/#{'user'}.rb"}

      it do
        result = parser.parse

        expect(result.first.definition).to match_sexp user_contents
      end
    end

    context "file: user_with_header" do
      let(:filename) { "spec/example_factories/#{'user_with_header'}.rb"}

      it do
        result = parser.parse

        expect(result.first.definition).to match_sexp user_contents
      end
    end

    context "file: user_admin" do
      let(:filename) { "spec/example_factories/#{'user_admin'}.rb"}

      it do
        result = parser.parse

        user, admin = result

        expect(user.definition).to match_sexp user_contents
        expect(admin.definition).to match_sexp admin_contents
      end
    end

    context "file: user_admin_with_header" do
      let(:filename) { "spec/example_factories/#{'user_admin_with_header'}.rb"}

      it do
        result = parser.parse

        expect(result.first.definition).to match_sexp user_contents
      end
    end
  end
end
