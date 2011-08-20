module ToFactory
  class Generator
    def factory model
      out = "Factory #{model} do |#{model.to_s[0..0].downcase}|\n"
      out << yield if block_given?
      out << "end"
    end
  end
end
