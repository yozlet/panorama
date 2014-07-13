
def foo
  x = 12
  bar(x)
end

def bar(i)
  baz(i+1)
end

def baz(i)
  i+1
end

foo()