describe ToFactory::Parsing::File do
  let(:user_contents) { File.read "spec/example_factories/#{version}_syntax/user.rb" }
  let(:admin_contents) { File.read "spec/example_factories/#{version}_syntax/admin.rb"}

  let(:parser) { ToFactory::Parsing::File.from_file(filename) }

  describe "#multiple_factories? and #header?" do
    context "new syntax" do
      tests = if ToFactory.new_syntax?

                #file,                      multiple, header
                [
                  ["user",                   false,   false],
                  ["user_with_header",       false,   true],
                  ["user_admin",             true,    false],
                  ["user_admin_with_header", true,    true]
                ]
              else
                [
                  ["user",                   false,   false],
                  ["user_admin",             true,    false],
                ]
              end

      tests.each do |file, multiple, header|
        context "with #{header ? 'header' : 'no header'} and #{multiple ? 'multiple factories' : 'one factory'}" do
          context "file: #{file}" do
            let(:filename) { "spec/example_factories/#{version}_syntax/#{file}.rb"}

            it { expect(parser.multiple_factories?).to eq multiple }
            it { expect(parser.header?).to eq header }
          end
        end
      end
    end
  end

  describe "#parse" do
    context "with bug" do
      let(:filename) { "spec/example_factories/#{version}_syntax/#{'buggy_country'}.rb"}

      it do
        result = parser.parse[ToFactory::User]

        expect(result[:"to_factory/country" ]).to match_sexp "123"
      end
    end

    context "file: user" do
      let(:filename) { "spec/example_factories/#{version}_syntax/#{'user'}.rb"}

      it do
        result = parser.parse[ToFactory::User]

        expect(result[:"to_factory/user" ]).to match_sexp user_contents
      end
    end

    context "file: user_with_header" do
      let(:filename) { "spec/example_factories/#{version}_syntax/#{'user_with_header'}.rb"}

      it do
        result = parser.parse[ToFactory::User]

        expect(result[:"to_factory/user" ]).to match_sexp user_contents
      end
    end

    context "file: user_admin" do
      let(:filename) { "spec/example_factories/#{version}_syntax/#{'user_admin'}.rb"}

      it do
        result = parser.parse

        expect(result.keys).to match_array [ToFactory::User]
        users = result[ToFactory::User]

        expect(users[:"to_factory/user" ]).to match_sexp user_contents
        expect(users[:admin]).to match_sexp admin_contents
      end
    end

    context "file: user_admin_with_header" do
      let(:filename) { "spec/example_factories/#{version}_syntax/#{'user_admin_with_header'}.rb"}

      it do
        result = parser.parse[ToFactory::User]

        expect(result[:"to_factory/user" ]).to match_sexp user_contents
      end
    end
  end
end
