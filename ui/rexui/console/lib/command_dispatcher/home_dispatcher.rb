###
#
# Dispatcher for primary commands
#
###

require "poortego/lib/core/poortego_core"
require "poortego/lib/helpers/poortego_session"

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
  include PoortegoCommands
  
  #
  # Constructor
  #
  def initialize(driver)
    super  
    
    ## TODO: trying to add rexui session info here
    @poortego_session = Poortego_Session.new()
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
      "poortego_exit"     => "Exit the console",
      "exit"              => "Alias for poortego_exit command",       
      "quit"              => "Alias for poortego_exit command",
 
      # BACK / HOME commands (completed)
      "poortego_back"     => "Return to previous dispatcher level",
      "back"              => "Alias for poortego_back command",
      "poortego_home"     => "Return to home level",
      "home"              => "Alias for poortego_home command",
      
      # CURRENT / SHOW commands (completed)
      "poortego_current"  => "Display the current state of things",
      "current"           => "Alias for poortego_current command",
      "poortego_show"     => "Show a current object (at current selection or parents)",
      "show"              => "Alias for poortego_show command",
      
      # CONNECT / DISCONNECT commands (TODO)
      ## Connect tested with connecting to another SQLite DB
      ## TODO: need a way of building a new database
      "poortego_connect"    => "Connect to DB (TODO: move constructor to allow on-the-fly DB connectivity)",
      "connect"             => "Alias for poortego_connect",
      "poortego_disconnect" => "Remove current DB connection, and re-establish previous DB connection",  # TODO
      "disconnect"          => "Alias for poortego_disconnect",
      
      # LIST command (completed)
      "poortego_list"       => "List available objects (at current selection or parents)",
      "list"                => "Alias for poortego_list command",
      "ls"                  => "Alias for poortego_list command",
     
      # SELECT command (completed)     
      "poortego_select"     => "Select an object to manipulate",
      "select"              => "Alias for poortego_select command",
      "use"                 => "Alias for poortego_select command",
      "cd"                  => "Alias for poortego_select command",
      
      # CREATE command (completed)  
      "poortego_create"    => "Create an object or object field",
      "create"             => "Alias for poortego_create command",
      "add"                => "Alias for poortego_create command",
      
      # SET command (completed)
      "poortego_set"    => "Set atrribute or field values for current object",
      "set"             => "Alias for poortego_set command",
      "update"          => "Alias for poortego_set command",
      
      # DELETE command (completed)
      "poortego_delete" => "Delete an object or object field",
      "delete"          => "Alias for poortego_delete command",
      "rm"              => "Alias for poortego_delete command",
      "del"             => "Alias for poortego_delete command",
      
      # RUN command (TODO)
      "poortego_run"    => "Run transform/plugin in the current scope",
      "run"             => "Alias for poortego_run",
      
      # EXPORT command (graphviz supported only atm, more TODO)
      "poortego_export" => "Export data in the current scope to a specific format (e.g., graph)",
      "export"          => "Alias for poortego_export",
      
      # IMPORT command (TODO)
      "poortego_import" => "Import CSV, pcap, XML, JSON, etc.",
      "import"          => "Alias for poortego_import",
      
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
  alias cmd_exit        cmd_poortego_exit
  alias cmd_quit        cmd_poortego_exit
  alias cmd_list        cmd_poortego_list
  alias cmd_ls          cmd_poortego_list
  alias cmd_delete      cmd_poortego_delete
  alias cmd_rm          cmd_poortego_delete
  alias cmd_del         cmd_poortego_delete
  alias cmd_select      cmd_poortego_select
  alias cmd_use         cmd_poortego_select
  alias cmd_cd          cmd_poortego_select
  alias cmd_create      cmd_poortego_create
  alias cmd_add         cmd_poortego_create
  alias cmd_set         cmd_poortego_set
  alias cmd_update      cmd_poortego_set
  alias cmd_run         cmd_poortego_run
  alias cmd_connect     cmd_poortego_connect
  alias cmd_disconnect  cmd_poortego_disconnect
  alias cmd_export      cmd_poortego_export
  alias cmd_import      cmd_poortego_import
  alias cmd_show        cmd_poortego_show
  alias cmd_current     cmd_poortego_current
  alias cmd_home        cmd_poortego_home
  alias cmd_back        cmd_poortego_back
 
end  # Class end

end end end  # Module ends
