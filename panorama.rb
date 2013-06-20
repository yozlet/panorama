require 'json'

class Panorama

  EVENTS = ["call", "return", "line"]
  attr_accessor :invocations

  def initialize()
    @invocations = []

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

  def dump(filename)
    file = File.new(filename, 'w')
    if invocations
      invocations.each do |inv|
        file.puts JSON.dump(inv)
      end
    end
    file.close
  end

  private

  def this_file(tp)
    tp.path == File.realpath(__FILE__)
  end

  def tpe_call
    TracePoint.new(:call) do |tp|
        $__pan_current_method_id = tp.method_id
        event_hash = {
          type: 'call',
          method_id: $__pan_current_method_id,
          path: tp.path,
          lineno: tp.lineno,
          args: tp.binding.eval(<<-'CODE')}
              if __method__
                __pan_lv = local_variables
                __pan_mid = $__pan_respond_to.bind(self).call(__method__, true) ? __method__ : $__pan_current_method_id
                $__pan_method.bind(self)
                  .call(__pan_mid)
                  .parameters
                  .inject({}) { |__pan_h,__pan_a|
                    __pan_h[__pan_a[1]] = eval("#{__pan_a[1]}") if __pan_lv.include?(__pan_a[1])
                    __pan_h
                  }
              end
          CODE
        @invocations << event_hash unless this_file(tp)
    end
  end

  def tpe_line
    TracePoint.new(:line) do |tp|
      @invocations << {
        type: 'line',
        method_id: tp.method_id,
          lineno: tp.lineno,
          locals: tp.binding.eval('local_variables.map{|v| [ v, eval("#{v}.inspect") ]}')
      } unless this_file(tp)
    end
  end

  def tpe_return
    TracePoint.new(:return) do |tp|
      @invocations << {
        type: 'return',
        method_id: tp.method_id,
          path: tp.path,
          lineno: tp.lineno,
          val: tp.return_value.inspect
      } unless this_file(tp)
    end
  end

end
