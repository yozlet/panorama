module Panorama
  class Invocation

    attr_accessor :method_name, :start_line, :exit_line, :path, :return_value

    def initialize(options)
      @method_name = options[:method_name]
      @start_line = options[:start_line]
      @path = options[:path]
    end

  end
end
