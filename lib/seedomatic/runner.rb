

module SeedOMatic
  module Runner
    extend self

    def run (opts = {})
      results = {}

      files_to_import(opts).each do |file|
        file_info = load_file(file)

        if should_import?(opts, file_info)
          results[file_info[:model_name]] = Seeder.new(file_info).import
        end
      end

      results
    end

  protected

    def should_import?(import_options, file_info)
      (!import_options[:tagged_with]  || ([*import_options[:tagged_with]] - [*file_info[:tags]]).empty?) &&
      (!import_options[:not_tagged_with] || ([*import_options[:not_tagged_with]] & [*file_info[:tags]]).empty?)
    end

    def files_to_import(options)
      if options[:file]
        [options[:file]]
      else
        dir = options[:dir] || "config/seeds"
        Dir.open(dir).map{|f| "#{dir}/#{f}"}.select{|file| File.file? file}
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