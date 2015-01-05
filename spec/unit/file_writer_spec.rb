describe ToFactory::FileWriter do
  let(:fw) { ToFactory::FileWriter.new }

  describe "#write" do
    def user_file
      File.read("tmp/factories/to_factory/user.rb")
    end

    def project_file
      File.read("tmp/factories/to_factory/project.rb")
    end

    it "adds factories for all models" do
      fw.write({ToFactory::User =>{:user => "factory a"},
                ToFactory::Project => {:project =>"factory b"}
      })

      if ToFactory.new_syntax?
        expect(user_file).to match /FactoryGirl.define do/
      end
      expect(user_file).to include "factory a"
      expect(project_file).to include "factory b"
    end
  end



end
