current_dir = File.expand_path(File.dirname(__FILE__))

class CMD_Run
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
  # Run command logic
  #
  def cmd_export(*args)
    # TODO
  end
  
  #
  # Run command help
  #
  def cmd_run_help(*args)
    print_status("Command    : run")
    print_status("Description: run transforms for things at current level.")
    print_status("Usage      : 'run'")
  end
  
end