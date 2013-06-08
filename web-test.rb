#!/usr/bin/env ruby

def foo(a, b)
  res = []
  a.times do |n|
    res << bar(n,b)
  end
  res
end

def bar(n,x)
  baz(n-1, x+n) + bing(x)
end

def bing(x)
  x * x
end

def baz(n, x)
  if n % 2 == 1
    return x * n
  else
    return x
  end
end

def main
  foo 3, 4
end


main
