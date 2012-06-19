require 'sqlite3'
require 'active_record'

module PoortegoCore

    begin
      # Load database config from yaml file
      local_lib_path = ENV['POORTEGO_LOCAL_LIB']
      config = YAML::load(IO.read("#{local_lib_path}/rails/config/database.yml"))

      # Establish ActiveRecord Connection, update this based on the connection type
      ActiveRecord::Base.establish_connection(config['development'])

      # Evaluate ActiveRecord models -- below loop not really needed:
      #Dir["#{local_lib_path}/rails/app/models/*.rb"].each { |file|
      #  eval(IO.read(file), binding)
      #}
    rescue Exception => e
      puts "Exception establishing activerecord connection"
      puts self.inspect
      puts e.message
    end

    #
    # Require Core Files
    #
    core_path = File.expand_path(File.dirname(__FILE__))
    Dir["#{core_path}/*.rb"].each { |core_file|
      require "#{core_file}"
    }

end