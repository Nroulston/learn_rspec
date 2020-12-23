require 'sequel'

DB = Sequel.sqlite("./db/#{ENV.fetch('Rack_ENV', 'development' )}.db")