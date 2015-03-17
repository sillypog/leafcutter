Gem::Specification.new do |s|
  s.name = 'leafcutter'
  s.version = '0.0.1'
  s.date = '2015-03-17'
  s.summary = 'Find leaves in tree-like json structures'
  s.authors = ['Peter Hastie']
  s.email = 'pete@sillypog.com'
  s.files = ['lib/leafcutter.rb']
  s.homepage = 'http://rubygems.org/gems/leafcutter'
  s.license = 'MIT'
  s.add_development_dependency 'json', '~> 1.8.2'
  s.add_development_dependency 'rspec', '~> 3.2.0'
end