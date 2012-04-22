require "seedomatic/version"

module SeedOMatic
  autoload :Seeder, 'seedomatic/seeder'
  autoload :Runner, 'seedomatic/runner'

  extend Runner
end
