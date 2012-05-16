# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "jasper-rails/version"

Gem::Specification.new do |s|
  s.name        = "jasper-rails"
  s.version     = JasperRails::VERSION
  s.authors     = ["Marlus Saraiva", "Rodrigo Maia"]
  s.summary     = %q{Rails and JasperReports integration}
  s.description = %q{Generate pdf reports on Rails using Jasper Reports reporting tool}

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency('rspec', '>= 2.8.0')
  s.add_dependency('rspec-rails', '>= 2.8.0')
  s.add_dependency('rjb', '>= 1.4.0')
  s.add_dependency('pdf-inspector', '>= 1.0.1')
end