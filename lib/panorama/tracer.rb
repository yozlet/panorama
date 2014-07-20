module Panorama
  class Tracer

    attr_accessor :current_invocation, :stack, :invocation_set

    def trace
      tracepoint.enable { yield }
      invocation_set
    end

    def trace_file(filename)
      if filename
        code = File.read(filename)
        tracepoint.enable do
          eval(code, nil, filename, 1)
        end
      end
      invocation_set
    end

    private

    def tracepoint
      init_tracepoint
      TracePoint.new(:call, :return) do |tp|
        case tp.event
        when :call
          open_invocation(tp)
        when :return
          close_invocation(tp)
        end
      end
    end

    def init_tracepoint
      @invocation_set = []
      @current_invocation = nil
      @stack = []
    end

    def open_invocation(tp)
      @stack << @current_invocation if @current_invocation
      @current_invocation = Invocation.new(
        method_name: tp.method_id,
        start_line: tp.lineno,
        path: tp.path
      )
      @invocation_set << @current_invocation
    end

    def close_invocation(tp)
      @current_invocation.return_value = tp.return_value
      @current_invocation.exit_line = tp.lineno
      @current_invocation = stack.pop
    end

  end
end
