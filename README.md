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

## Monads
