require './panorama.rb'
require 'pry'

def my_method(foo, bar)
  stuff = 0
  foo = "hello"
  "This #{foo} string"
  baz = true
end

p = Panorama.new('out.log')
p.start
my_method 'this', that: "the other"
p.stop
puts p.invocations.inspect
p.dump('out.log')
