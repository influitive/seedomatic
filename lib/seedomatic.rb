require "seedomatic/version"
require "seedomatic/railtie" if defined?(Rails)

require 'yaml'
require 'active_support/core_ext'

module SeedOMatic
  autoload :Seeder, 'seedomatic/seeder'
  autoload :Runner, 'seedomatic/runner'

  extend Runner
end
