# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "seedomatic/version"

Gem::Specification.new do |s|
  s.name        = "seedomatic"
  s.version     = Seedomatic::VERSION
  s.authors     = ["Ryan Brunner"]
  s.email       = ["ryan@ryanbrunner.com"]
  s.homepage    = "http://github.com/ryanbrunner/seedomatic"
  s.summary     = %q{Seed-O-Matic makes seeding easier.}
  s.description = %q{Create repeatable seed fixtures that you can continually use and deploy to multiple environments and tenants.}

  s.rubyforge_project = "seedomatic"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  s.add_development_dependency "rspec", '~> 2.9.0'
  s.add_development_dependency "pry"
  s.add_runtime_dependency "activesupport"
end
