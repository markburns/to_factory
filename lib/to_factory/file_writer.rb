module ToFactory
  class FileWriter
    def initialize
      FileUtils.mkdir_p(ToFactory.factories)
    end

    def write(definitions)
      definitions.each do |klass_name, representations|
        write_to(klass_name) do
          wrap_factories(representations.map(&:definition))
        end
      end
    end

    private

    def write_to(name)
      mkdir(name)

      File.open(File.join(ToFactory.factories, "#{name}.rb"), "w") do |f|
        f << yield
      end
    end

    def wrap_factories(definitions)
      out =  "FactoryBot.define do\n"
      out << indent(definitions).join("\n\n")
      out << "\n" unless out[-1] == "\n"
      out << "end"
      out << "\n" unless out[-1] == "\n"
    end

    def indent(definitions)
      definitions.map do |d|
        if d[/\A\s\s/]
          d
        else
          lines = d.split("\n").map do |l|
            "  #{l}"
          end

          lines.join("\n")
        end
      end
    end

    def mkdir(name)
      return unless name.to_s["/"]
      dir = name.to_s.split("/")[0..-2]
      FileUtils.mkdir_p File.join(ToFactory.factories, dir)
    end
  end
end
