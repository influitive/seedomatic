

module SeedOMatic
  module Runner
    extend self

    def run (opts = {})
      results = {}

      files_to_import(opts).each do |file|
        file_info = load_file(file)

        file_info.each do |f|
          if should_import?(opts, f)
            results[f[:model_name]] = Seeder.new(f).import
          end
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
      data = YAML.load_file(file).map do |k, v|
        v.merge(:model_name => k).with_indifferent_access
      end
    end

  end
end