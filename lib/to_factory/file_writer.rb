module ToFactory
  class FileWriter
    def initialize
      FileUtils.mkdir_p(ToFactory.factories)
    end

    def write(definitions)
      definitions.each do |klass, factories|
        name = klass.name.underscore.gsub /^"|"$/, ""
        mkdir(name) if name.to_s["/"]

        File.open(File.join(ToFactory.factories, "#{name}.rb"), "w") do |f|
          f << wrap_factories(factories.values)
        end
      end
    end

    private

    def wrap_factories(factories)
      if ToFactory.new_syntax?
        modern_header(factories)
      else
        factories.join("\n\n")
      end
    end

    def modern_header(factories)
      out = "FactoryGirl.define do\n"
      out << factories.join("\n")
      out << "\nend\n"
    end

    def mkdir(name)
      dir = name.to_s.split("/")[0..-2]
      FileUtils.mkdir_p File.join(ToFactory.factories, dir)
    end
  end
end
