module TerseExpectSyntax
  class Returner
    def initialize(to_call)
      @to_call=to_call
    end
    def r(*args)
      @to_call.call(*args)
    end
  end

  #x(     @a,            :b,      "c").r          d
  #becomes
  #expect(@a).to_receive(:b).with("c").and_return d
  def x(target, expected_method, *received_args)
    receiver = expect(target).to receive(expected_method)
    if received_args.any?
      receiver = receiver.with(*received_args)
    end


    Returner.new(lambda {|*return_args| receiver.and_return(*return_args) })
  end
end
