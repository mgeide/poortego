###
#
# Dispatcher for "home" commands
#  and active record initializer
#
###

# Gems for DB connectivity
require 'sqlite3'
require 'active_record'

# Active Records
current_dir = File.expand_path(File.dirname(__FILE__))
require "#{current_dir}/../../../../../models/transform"
require "#{current_dir}/../../../../../models/project"
require "#{current_dir}/../../../../../models/section"
require "#{current_dir}/../../../../../models/section_descriptor"
require "#{current_dir}/../../../../../models/entity"
require "#{current_dir}/../../../../../models/entity_type"
require "#{current_dir}/../../../../../models/entity_type_field"
require "#{current_dir}/../../../../../models/entity_field"
require "#{current_dir}/../../../../../models/link"
require "#{current_dir}/../../../../../models/link_type"
require "#{current_dir}/../../../../../models/link_type_field"
require "#{current_dir}/../../../../../models/link_field"

#
# Put command logic in separate files
#  to limit the size of the dispatcher files
#
require "#{current_dir}/command_logic/CMD_functions"  # Any helper functions
require "#{current_dir}/command_logic/CMD_Connect"
require "#{current_dir}/command_logic/CMD_List"
require "#{current_dir}/command_logic/CMD_Select"
require "#{current_dir}/command_logic/CMD_Show"
require "#{current_dir}/command_logic/CMD_Create"
require "#{current_dir}/command_logic/CMD_Delete"
require "#{current_dir}/command_logic/CMD_Set"
require "#{current_dir}/command_logic/CMD_Run"
require "#{current_dir}/command_logic/CMD_Export"
require "#{current_dir}/command_logic/CMD_Import"

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
  # Constructor
  #
  def initialize(driver)
    super  
    
    begin
      # Load database config from yaml file
      current_dir = File.expand_path(File.dirname(__FILE__))
      config = YAML::load(IO.read("#{current_dir}/../../../../../../config/database.yml"))

      # Establish ActiveRecord Connection
      ActiveRecord::Base.establish_connection(config['development'])

      # Evaluate ActiveRecord models
      Dir["#{current_dir}/../../../../../models/*.rb"].each { |file|
        eval(IO.read(file), binding)
      }
    rescue Exception => e
      puts "Exception establishing activerecord connection"
      puts self.inspect
      puts e.message
    end
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
      
      # CONNECT command (TODO)
      "connect"   => "Connect to DB (TODO: move constructor to allow on-the-fly DB connectivity)",
      
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
  # "Back" command logic
  #
  def cmd_back(*args)
    if (driver.dispatcher_stack.size > 1 and driver.current_dispatcher.name != 'Home')          
      driver.interface.move_back()
      driver.destack_dispatcher
      set_prompt(driver)
    end
  end
 
  #
  # "Home" command logic
  #
  def cmd_home(*args)
    while (driver.dispatcher_stack.size > 1 and driver.current_dispatcher.name != 'Home')
      driver.destack_dispatcher
    end
    driver.interface.initialize_working_values()
    set_prompt(driver)
  end 
 
  #
  # "Connect" command: see CMD_Connect.rb
  #
  def cmd_connect(*args)
    cmd = CMD_Connect.new(driver)
    cmd.cmd_connect(*args)
  end

  def cmd_connect_help(*args)
    cmd = CMD_Connect.new(driver)
    cmd.cmd_connect_help(*args)
  end

  def cmd_connect_tabs(str, words)
    cmd = CMD_Connect.new(driver)
    cmd.cmd_connect_tabs(str, words)
  end
  
  #
  # "Current" command logic
  #
  def cmd_current(*args)
    if (args.length > 0)
      cmd_current_help
    else
      # Display Dispatcher shared variables in shellinterface.rb
      tbl = Rex::Ui::Text::Table.new('Indent' => 4,
                                   'Columns' => ['Field',
                                                 'Value'   ])
      current_values = driver.interface.get_working_values()
      current_values.each do |key,value|
        tbl << ["#{key} :", "#{value}"]
      end
                                                 
      puts "\n" + tbl.to_s + "\n"
    end
  end
  
  #
  # "Current" command help
  #
  def cmd_current_help(*args)
    print_status("Command    : current")
    print_status("Description: displays the current system variables related to the state of things.")
    print_status("Usage      : 'current'")
  end
  
  #
  # "Show" command, see: CMD_Show.rb
  #
  def cmd_show(*args)
    cmd = CMD_Show.new(driver)
    cmd.cmd_show(*args)
  end
  
  def cmd_show_help(*args)
    cmd = CMD_Show.new(driver)
    cmd.cmd_show(*args)
  end
  
  #
  # "List" command, see CMD_List.rb   
  #
  def cmd_list(*args)
    cmd = CMD_List.new(driver)
    cmd.cmd_list(*args)
  end
  
  def cmd_list_help(*args)
    cmd = CMD_List.new(driver)
    cmd.cmd_list_help(*args)
  end
  
  #
  # "Select" command, see CMD_Select.rb
  #
  def cmd_select(*args)
    current_dispatcher = driver.interface.working_values["Current Dispatcher"]
    cmd = CMD_Select.new(driver)
    cmd.cmd_select(*args)
    # Enstack selected object dispatcher as appropriate
    if (current_dispatcher != driver.interface.working_values["Current Dispatcher"])
        # Dispatcher object based on working_values["Current Dispatcher"] string value
        driver.enstack_dispatcher(Poortego::Console::CommandDispatcher::const_get(driver.interface.working_values["Current Dispatcher"]))
    end   
  end
  
  def cmd_select_help(*args)
    cmd = CMD_Select.new(driver)
    cmd.cmd_select_help(*args)
  end
  
  #
  # "Create" command, see CMD_Create.rb
  #
  def cmd_create(*args)
    current_dispatcher = driver.interface.working_values["Current Dispatcher"]
    cmd = CMD_Create.new(driver)
    cmd.cmd_create(*args)
    # Enstack created object dispatcher as appropriate
    if (current_dispatcher != driver.interface.working_values["Current Dispatcher"])
        # Dispatcher object based on working_values["Current Dispatcher"] string value
        driver.enstack_dispatcher(Poortego::Console::CommandDispatcher::const_get(driver.interface.working_values["Current Dispatcher"]))
    end      
  end
  
  def cmd_create_help(*args)
    cmd = CMD_Create.new(driver)
    cmd.cmd_create_help(*args)
  end
  
  #
  # "Set" command, see: CMD_Set.rb
  #
  def cmd_set(*args)
    cmd = CMD_Set.new(driver)
    cmd.cmd_set(*args)
  end
  
  def cmd_set_help(*args)
    cmd = CMD_Set.new(driver)
    cmd.cmd_set_help(*args)
  end
  
  #
  # "Delete" command, see: CMD_Delete.rb
  #
  def cmd_delete(*args)
    cmd = CMD_Delete.new(driver)
    cmd.cmd_delete(*args)
  end
  
  def cmd_delete_help(*args)
    cmd = CMD_Delete.new(driver)
    cmd.cmd_delete_help(*args)
  end
  
  #
  # Run command, see: CMD_Run.rb
  #
  def cmd_run(*args)
    cmd = CMD_Run.new(driver)
    cmd.cmd_run(*args)
  end
  
  def cmd_run_help(*args)
    cmd = CMD_Run.new(driver)
    cmd.cmd_run_help(*args)
  end
  
  #
  # Export command, see: CMD_Export.rb
  #
  def cmd_export(*args)
    cmd = CMD_Export.new(driver)
    cmd.cmd_export(*args)
  end
  
  def cmd_export_help(*args)
    cmd = CMD_Export.new(driver)
    cmd.cmd_export_help(*args)
  end

  #
  # Import command, see: CMD_Import.rb
  #
  def cmd_import(*args)
    cmd = CMD_Import.new(driver)
    cmd.cmd_import(*args)
  end
  
  def cmd_import_help(*args)
    cmd = CMD_Import.new(driver)
    cmd.cmd_import_help(*args)
  end

  #
  # "Exit" command logic
  #
  def cmd_exit(* args)
    driver.stop
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
