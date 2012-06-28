current_dir = File.expand_path(File.dirname(__FILE__))
require "#{current_dir}/helper_functions"

module Commands
  
  #
  # "Link" command logic
  #
  #  link <objA> <objB>
  #
  def cmd_link(*args)  ## TODO: move this to "create" command
    
    if (args.length != 2)
      cmd_link_help
      return
    end

    objA_name  = args[0]
    objB_name  = args[1]
    link_name  = "#{objA_name} --> #{objB_name}"  ## Default link name: "obJA --> objB"
    
    link_obj = PoortegoLink.select_or_insert(driver.interface.working_values["Current Project"], 
                                     driver.interface.working_values["Current Section"], 
                                     objA_name, objB_name, link_name)
    
    unless (link_obj.nil?)
      driver.interface.working_values["Current Link"] = link_obj
      driver.interface.working_values["Current Object"] = driver.interface.working_values["Current Link"]
      driver.interface.working_values["Current Selection Type"] = 'link'
      driver.enstack_dispatcher(LinkDispatcher)
      set_prompt
    else
      print_error("Error creating link")
      return
    end
  end
  
  #
  # "Link" command help
  #
  def cmd_link_help(*args)
    print_status("Command    : link")
    print_status("Description: create a link between two objects.")
    print_status("Usage      : 'link <objA> <objB>'")
    print_status("Note: the default link name is '<objA> --> <objB>'")
  end
  
end