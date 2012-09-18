module Commands
  
  #
  # "Exit" command logic
  #
  def cmd_exit(* args)
    driver.stop
  end
  
end