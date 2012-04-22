require 'yaml'

module SeedOMatic
  module Runner
    extend self

    def run (opts)
      Seeder.new(get_data(opts))
    end

  protected

    def get_data(opts)
      data = YAML.load_file(opts[:file])
      { :model_name => data.keys.first, :items => data.first[1]['items'] }
    end

  end
end