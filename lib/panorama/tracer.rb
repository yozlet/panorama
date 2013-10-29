module Panorama
  class Tracer

    attr_accessor :current_invocation, :stack, :invocation_set

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
      get_tracepoint.enable { yield }
      invocation_set
    end

    def trace_file(filename)
      if filename
        code = File.read(filename)
        get_tracepoint.enable do
          eval(code, nil, filename, 1)
        end
      end
      invocation_set
    end

    private

    def get_tracepoint
      @invocation_set = []
      @current_invocation = nil
      @stack = []
      TracePoint.new(:call, :return) do |tp|
        case tp.event
          when :call
            stack << current_invocation if current_invocation
            @current_invocation = Invocation.new( {
              method_name: tp.method_id,
              start_line: tp.lineno,
              path: tp.path
            })
            invocation_set << @current_invocation
          when :return
            current_invocation.return_value = tp.return_value
            current_invocation.exit_line = tp.lineno
            @current_invocation = stack.pop
        end
      end
    end            

  end
end