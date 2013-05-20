require 'json'

class Panorama

  EVENTS = ["call", "return"]

  def initialize(filename)
    @file = File.new(filename, 'w')

    # Load up event callbacks
    @callbacks = EVENTS.map {|s| self.send("tpe_#{s}".to_sym) }

    # TODO: Replace with a single object
    $__pan_method = Object.instance_method(:method)
    $__pan_respond_to = Object.instance_method(:respond_to?)
    $__pan_current_method_id = nil
  end

  def start
    @callbacks.each {|c| c.enable }
  end

  def stop
    @callbacks.each {|c| c.disable }
  end

  private

  def _this_file(tp)
    tp.path == File.realpath(__FILE__)
  end

  def tpe_call
    TracePoint.new(:call) do |tp|
        $__pan_current_method_id = tp.method_id
        @file.puts JSON.dump({
          type: 'call',
          method_id: $__pan_current_method_id,
          path: tp.path,
          lineno: tp.lineno,
          args: tp.binding.eval(<<-'CODE')}) unless _this_file(tp)
              if __method__
                __pan_lv = local_variables
                __pan_mid = $__pan_respond_to.bind(self).call(__method__, true) ? __method__ : $__pan_current_method_id
                $__pan_method.bind(self)
                  .call(__pan_mid)
                  .parameters
                  .inject({}) { |__pan_h,__pan_a|
                    __pan_h[__pan_a[1]] = eval("#{__pan_a[1].to_s}.inspect") if __pan_lv.include?(__pan_a[1])
                    __pan_h
                  }
              end
          CODE
        # outfile.puts tp.binding.eval('local_variables.join(",")')
    end
  end

  def tpe_return
    TracePoint.new(:return) do |tp|
      @file.puts JSON.fast_generate({
        type: 'return',
        method_id: tp.method_id,
          path: tp.path,
          lineno: tp.lineno,
          val: tp.return_value.inspect
      }) unless _this_file(tp)
    end
  end

end
