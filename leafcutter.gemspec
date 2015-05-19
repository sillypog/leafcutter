Gem::Specification.new do |s|
  s.name = 'leafcutter'
  s.version = '0.0.4'
  s.date = '2015-05-19'
  s.summary = 'Find leaves in tree-like json structures'
  s.authors = ['Peter Hastie']
  s.email = 'pete@sillypog.com'
  s.files = ['lib/leafcutter.rb']
  s.homepage = 'https://github.com/sillypog/leafcutter'
  s.license = 'MIT'
  s.add_development_dependency 'json', '~> 1.8'
  s.add_development_dependency 'rspec', '~> 3.2'
end
