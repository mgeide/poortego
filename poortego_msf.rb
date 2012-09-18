#
# Start of an attempted Metasploit Plugin for Poortego
#

if ENV['POORTEGO_LOCAL_BASE']
  $:.unshift(ENV['POORTEGO_LOCAL_BASE']) 
end

require "poortego/lib/helpers/poortego_session"
require "poortego/lib/core/poortego_core"

module Msf

  class Plugin::Poortego < Msf::Plugin
  
    class ConsoleCommandDispatcher
      include Msf::Ui::Console::CommandDispatcher
      
      #
      # Load Command Scripts from the commands directory
      #
      #command_script_path = File.expand_path(File.join(File.dirname(__FILE__), 'commands'))
      #$:.unshift(File.join(File.dirname(__FILE__), 'ui/rexui/console/lib/command_dispatcher/commands'))
      command_script_path = File.expand_path(File.join(ENV['POORTEGO_LOCAL_BASE'], '/poortego/ui/rexui/console/lib/command_dispatcher/commands'))
      Dir["#{command_script_path}/*_cmd.rb"].each { |command_script|
      #command_script = "#{command_script_path}/list_cmd.rb"     
        #puts "[DEBUG] loading #{command_script}"
        load "#{command_script}"
      }
      include PoortegoCommands
      
      
      
      def initialize(driver)
        super
        @poortego_session = Poortego_Session.new()
      end
      
      def name
        "Poortego"
      end
      
      #
      # Supports these commands
      #
      def commands  # Note, most commands have an alias
      {
      # HELP commands (completed)
      #"?"         => "Help menu",
      #"poortego_help"      => "Help menu (alias)",
      
      # EXIT commands (completed)
      "poortego_exit"      => "Exit the console",
      "poortego_quit"      => "Alias for exit command",
 
      # BACK / HOME commands (completed)
      "poortego_back"      => "Return to previous dispatcher level",
      "poortego_home"      => "Return to home level",
      
      # CURRENT / SHOW commands (completed)
      "poortego_current"   => "Display the current state of things",
      "poortego_show"      => "Show a current object (at current selection or parents)",
      
      # CONNECT / DISCONNECT commands (TODO)
      ## Connect tested with connecting to another SQLite DB
      ## TODO: need a way of building a new database
      "poortego_connect"    => "Connect to DB (TODO: move constructor to allow on-the-fly DB connectivity)",
      "poortego_disconnect" => "Remove current DB connection, and re-establish previous DB connection",  # TODO
      
      # LIST command (completed)
      "poortego_list"      => "List available objects (at current selection or parents)",
      "poortego_ls"        => "Alias for list command",
     
      # SELECT command (completed)     
      "poortego_select"    => "Select an object to manipulate",
      "poortego_use"       => "Alias for select command",
      "poortego_cd"        => "Alias for select command",
      
      # CREATE command (completed)
      "poortego_create"    => "Create an object or object field",
      "poortego_add"       => "Alias for create command",
      
      # SET command (completed)
      "poortego_set"       => "Set atrribute or field values for current object",
      "poortego_update"    => "Alias for set command",
      
      # DELETE command (completed)
      "poortego_delete"    => "Delete an object or object field",
      "poortego_rm"        => "Alias for delete command",
      "poortego_del"       => "Alias for delete command",
      
      # RUN command (TODO)
      "poortego_run"       => "Run transform/plugin in the current scope",
      
      # EXPORT command (graphviz supported only atm, more TODO)
      "poortego_export"    => "Export data in the current scope to a specific format (e.g., graph)",
      
      # IMPORT command (TODO)
      "poortego_import"    => "Import CSV, pcap, XML, JSON, etc.",      
      }
      end
      
      #
      # Command Aliases
      #
      alias cmd_poortego_quit   cmd_poortego_exit
      alias cmd_poortego_ls     cmd_poortego_list
      alias cmd_poortego_rm     cmd_poortego_delete
      alias cmd_poortego_del    cmd_poortego_delete
      alias cmd_poortego_use    cmd_poortego_select
      alias cmd_poortego_cd     cmd_poortego_select
      alias cmd_poortego_add    cmd_poortego_create
      alias cmd_poortego_update cmd_poortego_set
      
    end # Dispatch Class end
  
    def initialize(framework, opts)
      super
                        
      add_console_dispatcher(ConsoleCommandDispatcher)
      @poortego_msf_ver = "0.1" # Plugin Version.  Increment each time we commit to msf
      print_status("Poortego Plugin for Metasploit #{@poortego_msf_ver}")
      print_good("Type %bldpoortego_help%clr for a command listing")
    end

    def cleanup
      remove_console_dispatcher('Poortego')
    end

    def name
      "poortego"
    end

    def desc
      "Poortego Plugin for Metasploit #{@poortego_msf_ver}"
    end
    protected
  
  end # Plugin Class end
end  # Module end
