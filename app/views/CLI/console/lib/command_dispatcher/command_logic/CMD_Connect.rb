class CMD_Connect
  attr_accessor :driver

  include Rex::Ui::Text::DispatcherShell::CommandDispatcher

  #
  # Constructor
  #
  def initialize(driver)
    super
    
    self.driver = driver
  end
  
  @@connect_opts = Rex::Parser::Arguments.new(
    "help" => [ false, "Help"],
    "database" => [ true, "Database Connection"],
    "test" => [ false, "Testing Connection"]
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
    
    @@connect_opts.parse(args) {|opt, idx, val|
      #print_line "[DEBUG] opt #{opt} idx #{idx} val #{val}"
      case val  # Change this to opt if "-h" style arguments are being passed
                # Change this to val if "help" style arguments are being passed
        when "help"
          cmd_connect_help
        when "database"
          print_line "Opt: #{opt}"
          print_line "Idx: #{idx}"
          print_line "Val: #{val}"
        when "test"
          print_line "Opt: #{opt}"
          print_line "Idx: #{idx}"
          print_line "Val: #{val}"
        else
          print_error("Invalid option.")
          return
        end  
    }
    
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