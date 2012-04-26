namespace :seedomatic do
  desc "Run Seed-O-Matic seed fixtures"
  task :seed => :environment do
    SeedOMatic.run :dir => ENV['SEED_DIRECTORY']
  end
end