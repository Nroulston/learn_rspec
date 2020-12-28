RSpec.configure do |c|
  #Suite level hooks runs after all the specs have been loaded, but before the first one runs.
  # Differs from before hooks which run before each example
  c.before(:suite) do
    Sequel.extension :migration
    Sequel::Migrator.run(DB, 'db/migrations')
    DB[:expenses].truncate
  end
end

#Spec suite should set up the test databse for you. Best practice