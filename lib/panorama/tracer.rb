module Panorama
  class Tracer

    attr_accessor :current_invocation, :stack, :invocation_set,
                  :invocation_roots

    def trace
      begin
        tracepoint.enable { yield }
      rescue StandardError, ScriptError => e
        invocation_set << $!
      end
      get_results
    end

    def trace_file(filename)
      if filename
        code = File.read(filename)
        begin
          tracepoint.enable do
            eval(code, nil, filename, 1)
          end
        rescue StandardError, ScriptError => e
          invocation_set << $!
        end
      end
      get_results
    end

    private

    def get_results
      {
        invocations: @invocation_set,
        roots: @invocation_roots
      }
    end

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
      @invocation_roots = []
      @current_invocation = nil
      @stack = []
    end

    def open_invocation(tp)
      new_invocation = Invocation.new(
        method_name: tp.method_id,
        start_line: tp.lineno,
        path: tp.path
      )
      @invocation_set << new_invocation
      if @current_invocation
        @stack << @current_invocation
        @current_invocation.add_child new_invocation
      else
        @invocation_roots << new_invocation
      end
      @current_invocation = new_invocation
    end

    def close_invocation(tp)
      @current_invocation.return_value = tp.return_value
      @current_invocation.exit_line = tp.lineno
      @current_invocation = stack.pop
    end

  end
end
