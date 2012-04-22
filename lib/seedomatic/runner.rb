

module SeedOMatic
  module Runner
    extend self

    def run (opts)
      files_to_import(opts).each do |file|
        puts file
        Seeder.new(load_file(file)).import
      end
    end

  protected

    def files_to_import(options)
      if options[:file]
        [options[:file]]
      else
        Dir.open(options[:dir] || "~/Code/seedomatic/config/seeds").map{|f| "#{options[:dir]}/#{f}"}.select{|file| File.file? file}
      end
    end

    def load_file(file)
      data = YAML.load_file(file)
      {
        :model_name => data.keys.first,
        :match_on => data.first[1]['match_on'],
        :items => data.first[1]['items']
      }
    end

  end
end