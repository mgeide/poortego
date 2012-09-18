#!/usr/bin/env ruby

# Gems for DB connectivity
require 'sqlite3'
require 'active_record'

begin
  current_dir = File.expand_path(File.dirname(__FILE__))
  config = YAML::load(IO.read("#{current_dir}/Rails/config/database.yml"))

  # Establish ActiveRecord Connection
  ActiveRecord::Base.establish_connection(config['development'])

  # Evaluate ActiveRecord models
  Dir["#{current_dir}/Core/*.rb"].each { |file|
        eval(IO.read(file), binding)
  }

rescue Exception => e
  puts "Exception establishing activerecord connection"
  puts self.inspect
  puts e.message
end