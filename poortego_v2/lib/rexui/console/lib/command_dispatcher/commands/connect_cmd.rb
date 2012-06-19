current_dir = File.expand_path(File.dirname(__FILE__))
require "#{current_dir}/helper_functions"

module Commands
  
    @@connect_opts = Rex::Parser::Arguments.new(
    "-h"        => [ false, "Help"],
    "-yaml"     => [ true,  "YAML config file to use"], 
    "-adapter"  => [ true,  "Define database adapter to use (e.g., sqlite3, mysql2)."],
    "-database" => [ true,  "The DB name or path to DB file in the case of SQLite."],
    "-username" => [ true,  "The DB username."],
    "-password" => [ true,  "The DB user credentials."],
    "-host"     => [ true,  "The system hosting the DB."]
    
    #"database" => [ true, "Database Connection"],
    #"test" => [ false, "Testing Connection"]
  )
  
  #
  # "Connect" command logic (TODO)
  #
  def cmd_connect(*args)
    ## TODO: add logic from Constructor
    if (args[0] == nil)
      cmd_connect_help
      return
    end
    
    connection_config = Hash.new()
    
    @@connect_opts.parse(args) {|opt, idx, val|
      #print_line "[DEBUG] opt #{opt} idx #{idx} val #{val}"
      #print_line "[DEBUG] opt class: #{opt.class}"
      #print_line "[DEBUG] Arg #{args[idx]}"
      #case opt  # Change this to opt if "-h" style arguments are being passed
                # Change this to val if "help" style arguments are being passed
      case (args[idx-1])
      when "-h", "-?"
          cmd_connect_help
        when "-adapter"
          connection_config['adapter'] = val
          puts "[DEBUG] Setting adapter to #{val}"
        when "-database"
          connection_config['database'] = val
          puts "[DEBUG] Setting database to #{val}"
        when "-username"
          connection_config['username'] = val
          puts "[DEBUG] Setting username to #{val}"
        when "-password"
          connection_config['password'] = val
          puts "[DEBUG] Setting password to #{val}"
        when "-host"
          connection_config['host'] = val
          puts "[DEBUG] Setting host to #{val}"  
        else
          print_error("Invalid option.")
          return
        end  
    }
    
    if (connection_config.length > 1)
      begin
        ActiveRecord::Base.establish_connection(connection_config)
      rescue Exception => e
        puts "Exception establishing activerecord connection"
        puts self.inspect
        puts e.message  
      end
    end
    
  end  
  
  #
  # "Connect" command help (TODO)
  #
  def cmd_connect_help(*args)
    print_status("TODO: a command to specify the DB connection.")
    print_line "Usage: connect [options]"
    print_line
    print @@connect_opts.usage()
  end
  
  #
  # Tab completion for connect command
  #
  def cmd_connect_tabs(str, words)
    return [] if words.length > 1
    res = %w{database help test}
    return res
  end
  
  
end