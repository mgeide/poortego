current_dir = File.expand_path(File.dirname(__FILE__))

class CMD_Import
  attr_accessor :driver

  include Rex::Ui::Text::DispatcherShell::CommandDispatcher

  #
  # Constructor
  #
  def initialize(driver)
    super
    
    self.driver = driver
  end
  
  #
  # Import command logic
  #
  def cmd_import(*args)
    # TODO
  end
  
  #
  # Import command help
  #
  def cmd_import_help(*args)
    print_status("Command    : import")
    print_status("Description: import data at current level.")
    print_status("Usage      : 'import <file>'")
  end
  
end