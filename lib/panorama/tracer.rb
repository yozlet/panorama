module Panorama
  class Tracer

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
      TracePoint.new(:call) do |tp|
        invocation_set << Invocation.new( {
          method_name: tp.method_id,
          lineno: tp.lineno,
          path: tp.path
        })
      end.enable do
        yield
      end
      invocation_set
    end

  end
end