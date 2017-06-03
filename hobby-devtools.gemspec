Gem::Specification.new do |g|
  g.name    = 'hobby-devtools'
  g.files   = `git ls-files`.split($/)
  g.version = '0.0.11'
  g.summary = 'My setup for development of Hobby-related projects.'
  g.authors = ['Anatoly Chernow']

  g.add_dependency 'hobby'
  g.add_dependency 'hobby-test', '>=0.0.3'
  g.add_dependency 'mutant'
  g.add_dependency 'mutant-rspec'
  g.add_dependency 'rspec'
  g.add_dependency 'rspec-power_assert'
  g.add_dependency 'pry'
  g.add_dependency 'awesome_print'
  g.add_dependency 'puma'
  g.add_dependency 'bgem'
end
