
current_dir = File.expand_path(File.dirname(__FILE__))
require "#{current_dir}/helper_functions"

module PoortegoCommands
  
  #
  # Select logic
  #
  def cmd_poortego_select(*args)
    type = ''
    name = '' 
    obj  = nil 
     
    if (args.length == 1)
      type = @poortego_session.session_values["Default Command Type"]
      name = args[0]
    elsif (args.length == 2)
      type = args[0]
      name = args[1]
    else    
      print_error("Invalid number of arguments passed to select command.")
      cmd_poortego_select_help
      return
    end
  
    case type
    when '-h', '-?' 
      cmd_poortego_select_help
      return
    when 'project'
      if (name =~ /^\d+$/) # ID
        obj = PoortegoProject.find(name)
      else
        obj = PoortegoProject.select(name)
      end
      @poortego_session.session_values["Current Project"] = obj
      @poortego_session.session_values["Current Object"] = @poortego_session.session_values["Current Project"]
      @poortego_session.session_values["Current Dispatcher"] = 'ProjectDispatcher'
    when 'section'
      if (name =~ /^\d+$/)
        obj = PoortegoSection.find(name)
      else
        obj = PoortegoSection.select( @poortego_session.session_values["Current Project"].id, name )
      end
      @poortego_session.session_values["Current Section"] = obj
      @poortego_session.session_values["Current Object"] = @poortego_session.session_values["Current Section"]
      @poortego_session.session_values["Current Dispatcher"] = 'SectionDispatcher'
    when 'transform'
      if (name =~ /^\d+$/)
        obj = PoortegoTransform.find(name)
      else
        obj = PoortegoTransform.select(name)
      end
      @poortego_session.session_values["Current Transform"] = obj
      @poortego_session.session_values["Current Object"] = @poortego_session.session_values["Current Transform"]
      @poortego_session.session_values["Current Dispatcher"] = 'TransformDispatcher'
    when 'entity'
      if (name =~ /^\d+$/)
        obj = PoortegoEntity.find(name)
      else
        obj = PoortegoEntity.select(@poortego_session.session_values["Current Project"].id, 
                            @poortego_session.session_values["Current Section"].id, 
                            name)
      end
      @poortego_session.session_values["Current Entity"] = obj
      @poortego_session.session_values["Current Object"] = @poortego_session.session_values["Current Entity"]
      @poortego_session.session_values["Current Dispatcher"] = 'EntityDispatcher'
    when 'link'
      if (name =~ /^\d+$/)
        obj = PoortegoLink.find(name)
      else
        obj = PoortegoLink.select_by_name(@poortego_session.session_values["Current Project"].id, 
                                  @poortego_session.session_values["Current Section"].id, 
                                  name)
      end
      @poortego_session.session_values["Current Link"] = obj
      @poortego_session.session_values["Current Object"] = @poortego_session.session_values["Current Link"]
      @poortego_session.session_values["Current Dispatcher"] = 'LinkDispatcher'
    when 'entity_type'
      if (name =~ /^\d+$/)
        obj = PoortegoEntityType.find(name)
      else
        obj = PoortegoEntityType.select(name)
      end
      @poortego_session.session_values["Current EntityType"] = obj
      @poortego_session.session_values["Current Object"] = @poortego_session.session_values["Current EntityType"]
      @poortego_session.session_values["Current Dispatcher"] = 'EntityTypeDispatcher'
    when 'link_type'
      if (name =~ /^\d+$/)
        obj = PoortegoLinkType.find(name)
      else
        obj = PoortegoLinkType.select(name)
      end
      @poortego_session.session_values["Current LinkType"] = obj
      @poortego_session.session_values["Current Object"] = @poortego_session.session_values["Current LinkType"]
      @poortego_session.session_values["Current Dispatcher"] = 'LinkTypeDispatcher'  
    else
      print_error("Invalid type: #{type}")
      return
    end
    
    #if (id < 1)
    if (obj.nil?)
      print_error("Invalid #{type} name, use list for list of valid #{type}s.")
      return   
    else
      #@poortego_session.session_values["Current Selection Type"] = type
      @poortego_session.session_values["Current Selection Type"] = type
      #driver.interface.update_default_type()
      @poortego_session.update_default_type()
      print_status("Selected #{type}, id #{obj.id}")
      set_prompt(driver)
    end
  end
  
  #
  # Select Help
  #
  def cmd_poortego_select_help(*args)
    print_status("Command    : select")
    print_status("Description: select a thing for manipulation.")
    print_status("Usage      : 'select [type] <name>'")
    print_status("Details    :")
    print_status("Where type is optional and name is required. Vaid types: project, section, transform, entity, link, entity_type, link_type.")
    print_status("The default type is the currently default type.")
  end
  
end
