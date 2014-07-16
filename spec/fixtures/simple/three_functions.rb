
def foo
  x = 4
  bar(x)
  3 * x
end

def bar(i)
  baz(i+1)
end

def baz(i)
  i+1
end

foo()