require 'rails'

module SeedOMatic
  class Railtie < Rails::Railtie
    rake_tasks do
      load 'tasks/seed.rake'
    end
  end
end