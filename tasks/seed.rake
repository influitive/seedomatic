namespace :seedomatic do
  desc "Run Seed-O-Matic seed fixtures"
  task :seed => :environment do
    results = SeedOMatic.run :dir => ENV['SEED_DIRECTORY'],
                             :tagged_with => ENV['SEED_TAGGED_WITH'],
                             :not_tagged_with => ENV['SEED_NOT_TAGGED_WITH']

    results.each do |model, counts|
      puts "#{model} - [#{counts[:new]} new | #{counts[:updated]} updated]"
    end
  end
end