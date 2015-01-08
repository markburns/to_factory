module ToFactory
  class FileWriter
    def initialize
      FileUtils.mkdir_p(ToFactory.factories)
    end

    def write(definitions)
      definitions.each do |klass, representations|
        name = klass.name.underscore.gsub /^"|"$/, ""
        mkdir(name) if name.to_s["/"]

        File.open(File.join(ToFactory.factories, "#{name}.rb"), "w") do |f|
          f << wrap_factories(representations.map(&:definition))
        end
      end
    end

    private

    def wrap_factories(definitions)
      if ToFactory.new_syntax?
        modern_header(definitions)
      else
        definitions.join("\n\n")
      end
    end

    def modern_header(definitions)
      out = "FactoryGirl.define do\n"
      out << definitions.join("\n")
      out << "\nend\n"
    end

    def mkdir(name)
      dir = name.to_s.split("/")[0..-2]
      FileUtils.mkdir_p File.join(ToFactory.factories, dir)
    end
  end
end
