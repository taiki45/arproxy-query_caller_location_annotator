# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'arproxy/query_caller_location_annotator/version'

Gem::Specification.new do |spec|
  spec.name          = 'arproxy-query_caller_location_annotator'
  spec.version       = Arproxy::QueryCallerLocationAnnotator::VERSION
  spec.authors       = ['Takatoshi Maeda', 'Taiki Ono']
  spec.email         = ['taiks.4559@gmail.com']

  spec.summary       = %q{Append query caller to each ActiveRecord's query log.}
  spec.description   = spec.summary
  spec.homepage      = 'https://github.com/taiki45/arproxy-query_caller_location_annotator'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'arproxy'
  spec.add_dependency 'rails'
  spec.add_development_dependency 'bundler', '~> 1.12'
  spec.add_development_dependency 'rake', '~> 10.0'
end
