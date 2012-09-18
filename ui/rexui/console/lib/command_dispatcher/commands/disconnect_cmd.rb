
current_dir = File.expand_path(File.dirname(__FILE__))
require "#{current_dir}/helper_functions"

module PoortegoCommands

  #
  # "Disconnect" command logic
  #
  def cmd_poortego_disconnect(*args)
     ## TODO
  end

  #
  # "Disconnect" command help (TODO)
  #
  def cmd_poortego_disconnect_help(*args)
    print_status("TODO: a command to specify the DB disconnect.")
    print_line "Usage: disconnect [options]"
  end
  
  #
  # Tab completion for disconnect command
  #
  def cmd_poortego_disconnect_tabs(str, words)
    ## TODO
    #return [] if words.length > 1
    #res = %w{database help test}
    #return res
  end

end