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

  end
end