
current_dir = File.expand_path(File.dirname(__FILE__))
require "#{current_dir}/helper_functions"

module PoortegoCommands
  
  #
  # "Link" command logic
  #
  #  link <objA> <objB>
  #
  def cmd_poortego_link(*args)  ## TODO: move this to "create" command
    
    if (args.length != 2)
      cmd_poortego_link_help
      return
    end

    objA_name  = args[0]
    objB_name  = args[1]
    link_name  = "#{objA_name} --> #{objB_name}"  ## Default link name: "obJA --> objB"
    
    link_obj = PoortegoLink.select_or_insert(@poortego_session.session_values["Current Project"], 
                                     @poortego_session.session_values["Current Section"], 
                                     objA_name, objB_name, link_name)
    
    unless (link_obj.nil?)
      @poortego_session.session_values["Current Link"] = link_obj
      @poortego_session.session_values["Current Object"] = @poortego_session.session_values["Current Link"]
      @poortego_session.session_values["Current Selection Type"] = 'link'
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
  def cmd_poortego_link_help(*args)
    print_status("Command    : link")
    print_status("Description: create a link between two objects.")
    print_status("Usage      : 'link <objA> <objB>'")
    print_status("Note: the default link name is '<objA> --> <objB>'")
  end
  
end

