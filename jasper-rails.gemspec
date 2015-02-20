# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "jasper-rails/version"

Gem::Specification.new do |s|
  s.name        = "jasper-rails"
  s.version     = JasperRails::VERSION
  s.authors     = ["Marlus Saraiva", "Rodrigo Maia"]
  s.summary     = %q{Rails and JasperReports integration}
  s.description = %q{Generate pdf reports on Rails using Jasper Reports reporting tool}
  s.email       = "marlussaraiva@grupofortes.com.br"
  s.homepage    = "https://github.com/fortesinformatica/jasper-rails"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency 'rjb-loader', '~>0.0.2'
  s.add_dependency 'nokogiri'
  s.add_dependency 'responders'

  s.add_development_dependency 'combustion', '~> 0.3.2'
  s.add_development_dependency "rspec-rails"
  s.add_development_dependency "jasper-rails-rspec"
end
