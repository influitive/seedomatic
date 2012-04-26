require 'rails'

module SeedOMatic
  class Railtie < Rails::Railtie
    rake_tasks do
      load File.expand_path(File.dirname(__FILE__) + "../../../tasks/seed.rake")
    end
  end
end