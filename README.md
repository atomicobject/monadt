# monadt
Monads &amp; ADTs in Ruby

## Overview 
Monadt supplies basic ADT and Monad support to Ruby. 

ADTs are defined as Ruby classes and support pattern matching with block callbacks per case.

Monads are defined using Ruby Enumerators to allow for imperative-like structures similar to the syntactic sugar available in Haskell and F#. The Maybe and Choice monads are defined using the ADT methods in Monadt.

## ADTs

Declare a new ADT with the following syntax:
```ruby
require 'monadt'

class MyAdt
  FooBar = data :a_number
  Baz = data # no assocated values
  Else = data :first_data_point, :second_data_point
end
```

Now you can pattern match using Monadt's match() method.
```ruby
def some_func(my_adt)
  match my_adt,
    with(MyAdt::FooBar) {|a_number| (a_number * 2).to_s },
    with(MyAdt::Baz) { 'bar bar bar' },
    with(MyAdt::Else) {|first, second| ((first + second) * 3).to_s }
end
```

You can also match against special class Default for matching all values:
```ruby
def another_func(my_adt)
  match my_adt,
    with(MyAdt::Else) {|first, second| first ** second },
    with(Default) { 1024 }
end
```

To declare a new value use the class constructor:
```ruby
MyAdt::FooBar.new 15
```

If you need to access the fields directly rather than with pattern matching, you can use the name associated with the data. For example,
```ruby
adt_value.a_number
adt_value.second_data_point
```
You will trigger a NoMethodError if you call a data field for the wrong case.

You can optionally add several useful helper functions to your ADT by calling
```ruby
decorate_adt MyAdt
```

You now have the following methods:
```ruby
MyAdt.foo_bar 23 # create a new FooBar (equivalent to MyAdt::FooBar.new 23)
MyAdt.baz # makes a new Baz
MyAdt.else 3, 11

adt_value.is_foo_bar? # boolean check for FooBar case
adt_value.is_baz?
adt_value.is_else?

adt_value.to_s # sensible defaults like "FooBar(11)", "Baz", "Else(34, 99)"
```

Decorating your ADTs is optional because you may not want all those helpers, and because I'm sure there is some class name transform case I didn't think of that will break everything in certain edge cases.

### TODO 

Make it easy to enforce immutability.

## Monads

Monadt uses Ruby Enumerators to support procedural like syntax for monad control flows. Generally you call
```ruby
Monad.<monad_name> do |m|
  # object m has two members,
  # * bind, which performs monadic bind for the specified monad
  # * return, which performs monadic return for the specified monad
end
```

### Built-in monads

* Maybe/Present
* Either
* State
* Reader
* ReaderStateEither

#### Maybe

```ruby
# values
Maybe.just 5
Maybe.nothing

# example
def maybeFunc(x)
  if x > 10
    Maybe.nothing
  else
    Maybe.just (x - 10)
  end
end

def use_maybe(v)
  Monad.maybe do |m|
    x = m.bind (maybeFunc v)
    y = m.bind (maybeFunc (x*2))
    m.return (x + y)
  end
end
```

Monadt also includes what I call the "Present" monad. It's just like Maybe except nil is interpreted as Nothing and non-nil values are interpreted as Just value.

#### Either

```ruby
# values
Either.left "something went wrong"
Either.right 15.0

# ...
def use_either(v)
  Monad.either do |m|
    x = m.bind (eitherFunc v)
    y = m.bind (eitherFunc2 x)
    eitherFunc3 (x + y)
  end
end
```

#### State

```ruby
# state values are two-element arrays
# [value, state]
proc = Monad.state do |m|
  x = m.bind (returns_a_proc v)
  y = m.bind (returns_a_proc_2 3 x)
  m.return (x + y)
end

value, final_state = proc.call(initial_state)

# If you want to run the state function and only care about the final output value, use:
Monad.run_state(initial_value) do |m|
   # ...
end
```

Note that for the State monad (or any monad whose monadic type is a function), you may find the funkify gem helpful, as it can make Ruby methods partially applicable such that they return a Proc.

#### Reader

```ruby
proc = Monad.reader do |m|
  x = m.bind (returns_a_proc_expecting_env 3)
  y = m.bind (returns_a_proc_expecting_env (x * 2))
  m.return (y + 10)
end
value = proc.call(env)

# OR

value = Monad.run_reader(env) do |m|
  # ...
end
```

#### ReaderStateEither

This monad combines Reader, State, and Either, having monadic form (env -> state -> Either<LeftType,[T,state]>).

### Creating new monads

Create a new monad by defining a class with two static methods, bind and return. They are implemented in standard monad fashion, slightly tweaked for ruby

```ruby
bind(m_a, &blk) # blk is a block of "signature" a -> m_b; this method must return m_b
return(val) # returns m_a
```

### A note about List Monad

Because the list monad requires executing the same (a -> m_b) multiple times with different values, it is not currently supported by the Enumerator syntax, as we cannot re-run the same segment of the enumerated block. We're working on coming up with a way around this problem.
