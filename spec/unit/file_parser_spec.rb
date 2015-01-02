describe ToFactory::FileParser do
  let(:parser) { ToFactory::FileParser.new() }

  describe "#parse" do
    context "new syntax" do
      let(:user_contents) do
        <<-USER
            factory :user do
              attribute_1 1
              attribute_2 2
            end
        USER
      end
      let(:admin_contents) do
        <<-ADMIN
            factory :admin, :parent => :user do
              attribute_1 3
              attribute_2 4
            end
        ADMIN
      end

      let(:file_contents) do
        <<-FILE
          FactoryGirl.define do
            #{user_contents}
            #{admin_contents}
          end
        FILE
      end

      it "reads entries from the file system" do
        expect(parser.parse).to eq(
          :user  => user_contents,
          :admin => admin_contents
        )
      end
    end
  end
end
