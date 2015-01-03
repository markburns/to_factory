RSpec::Matchers.define :match_sexp do |expected|
  match do |actual|
    parser = RubyParser.new

    parser.process(expected) == parser.process(actual)
  end

  failure_message do |actual|
    "expected \n#{actual}\n to match expected sexp of  \n#{expected}"
  end
end
