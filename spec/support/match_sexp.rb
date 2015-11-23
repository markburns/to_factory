RSpec::Matchers.define :match_sexp do |expected|
  match do |actual|
    parser = RubyParser.new

    begin
      parser.process(expected) == parser.process(actual)
    rescue Exception => e
      @raised = e
      false
    end
  end

  failure_message do |actual|
    message = "expected \n#{actual}\n\nto match expected sexp of\n\n#{expected}"

    if @raised
      message << "\nbut raised\n"
      message << @raised.message
    else
      message
    end
  end
end
