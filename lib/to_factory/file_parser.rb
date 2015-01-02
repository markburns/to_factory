module ToFactory
  class FileParser
    def self.parse(contents)
      new(contents).parse
    end

    def initialize(contents)
      @contents = contents
    end

    def parse
    end
  end
end
