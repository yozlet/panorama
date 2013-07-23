module Panorama
  class Tracer

    #attr_accessor :current_invocation, :stack, :invocation_set

    def initialize
      @active_state = false
    end

    def active?
      @active_state
    end

    def start
      @active_state = true
    end

    def stop
      @active_state = false
    end

    def trace
      invocation_set = []
      current_invocation = nil
      stack = []
      TracePoint.new(:call, :return) do |tp|
        case tp.event
          when :call
            stack << current_invocation if current_invocation
            current_invocation = Invocation.new( {
              method_name: tp.method_id,
              lineno: tp.lineno,
              path: tp.path
            })
            invocation_set << current_invocation
          when :return
            current_invocation.return_value = tp.return_value
            current_invocation.lineno = tp.lineno
            current_invocation = stack.pop
        end
      end.enable do
        yield
      end
      invocation_set
    end

  end
end