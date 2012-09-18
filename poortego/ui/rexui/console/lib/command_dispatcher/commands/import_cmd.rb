module Commands
  
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