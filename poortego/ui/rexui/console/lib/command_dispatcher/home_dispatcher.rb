###
#
# Dispatcher for primary commands
#
###

require "lib/core/poortego_core"

module Poortego
module Console
module CommandDispatcher

###
#
# Home Dispatcher Class
#
###
class HomeDispatcher
  
  include Poortego::Console::CommandDispatcher
  
  #
  # Load Command Scripts from the commands directory
  #
  command_script_path = File.expand_path(File.join(File.dirname(__FILE__), 'commands'))
  Dir["#{command_script_path}/*_cmd.rb"].each { |command_script|
    require "#{command_script}"
  }
  include Commands
  
  #
  # Constructor
  #
  def initialize(driver)
    super  
  end
  
  #
  # Supports these commands
  #
  def commands  # Note, most commands have an alias
    {
      # HELP commands (completed)
      "?"         => "Help menu",
      "help"      => "Help menu (alias)",
      
      # EXIT commands (completed)
      "exit"      => "Exit the console",
      "quit"      => "Alias for exit command",
 
      # BACK / HOME commands (completed)
      "back"      => "Return to previous dispatcher level",
      "home"      => "Return to home level",
      
      # CURRENT / SHOW commands (completed)
      "current"   => "Display the current state of things",
      "show"      => "Show a current object (at current selection or parents)",
      
      # CONNECT / DISCONNECT commands (TODO)
      ## Connect tested with connecting to another SQLite DB
      ## TODO: need a way of building a new database
      "connect"    => "Connect to DB (TODO: move constructor to allow on-the-fly DB connectivity)",
      "disconnect" => "Remove current DB connection, and re-establish previous DB connection",  # TODO
      
      # LIST command (completed)
      "list"      => "List available objects (at current selection or parents)",
      "ls"        => "Alias for list command",
     
      # SELECT command (completed)     
      "select"    => "Select an object to manipulate",
      "use"       => "Alias for select command",
      "cd"        => "Alias for select command",
      
      # CREATE command (completed)
      "create"    => "Create an object or object field",
      "add"       => "Alias for create command",
      
      # SET command (completed)
      "set"       => "Set atrribute or field values for current object",
      "update"    => "Alias for set command",
      
      # DELETE command (completed)
      "delete"    => "Delete an object or object field",
      "rm"        => "Alias for delete command",
      "del"       => "Alias for delete command",
      
      # RUN command (TODO)
      "run"       => "Run transform/plugin in the current scope",
      
      # EXPORT command (graphviz supported only atm, more TODO)
      "export"    => "Export data in the current scope to a specific format (e.g., graph)",
      
      # IMPORT command (TODO)
      "import"    => "Import CSV, pcap, XML, JSON, etc.",
      
    }
  end
  
  #
  # Dispatcher Name
  #
  def name
    "Home"
  end
  
  
  #
  # Command Aliases
  #
  alias cmd_quit   cmd_exit
  alias cmd_ls     cmd_list
  alias cmd_rm     cmd_delete
  alias cmd_del    cmd_delete
  alias cmd_use    cmd_select
  alias cmd_cd     cmd_select
  alias cmd_add    cmd_create
  alias cmd_update cmd_set
  
end  # Class end

end end end  # Module ends
