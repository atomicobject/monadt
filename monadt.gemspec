Gem::Specification.new do |s|
  s.name        = 'monadt'
  s.version     = '0.0.1'
  s.date        = '2016-03-25'
  s.summary     = "ADTs and Monads in Ruby"
  s.description = "Functions to create ADTs and do pattern matching, as well as Enumerator based Monad computation"
  s.authors     = ["Will Pleasant-Ryan"]
  s.email       = 'will.ryan@atomicobject.com'
  s.files       = ["lib/monadt.rb"] + Dir[ "lib/monadt/*.rb"]
  s.homepage    = 'https://github.com/atomicobject/monadt'
  s.license     = 'Apache'
end
