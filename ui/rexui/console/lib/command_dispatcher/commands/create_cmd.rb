
current_dir = File.expand_path(File.dirname(__FILE__))
require "#{current_dir}/helper_functions"

module PoortegoCommands

  #
  # Create command
  #
  def cmd_poortego_create(*args)
 
    type = ''
    name = '' 
    obj  = nil
     
    if (args.length == 1)
      if ((args[0] == '-h') || (args[0] == '-?'))
        cmd_poortego_create_help
        return
      end
      type = @poortego_session.session_values["Default Command Type"]
      name = args[0]
    elsif (args.length == 2)
      type = args[0]
      name = args[1]
    else    
      print_error("Invalid number of arguments passed to create command.")
      cmd_poortego_create_help
      return
    end
  
    case type
    when '-h', '-?' 
      cmd_poortego_create_help
      return
    when 'project'
      obj = PoortegoProject.select_or_insert(name)
      @poortego_session.session_values["Current Project"] = obj
      @poortego_session.session_values["Current Selection Type"] = type
      @poortego_session.session_values["Current Object"] = @poortego_session.session_values["Current Project"]
      @poortego_session.session_values["Current Dispatcher"] = 'ProjectDispatcher'
    when 'section'
      obj = PoortegoSection.select_or_insert(@poortego_session.session_values["Current Project"].id, name)
      @poortego_session.session_values["Current Section"] = obj
      @poortego_session.session_values["Current Selection Type"] = type
      @poortego_session.session_values["Current Object"] = @poortego_session.session_values["Current Section"]
      @poortego_session.session_values["Current Dispatcher"] = 'SectionDispatcher'
    when 'transform'
      obj = PoortegoTransform.select_or_insert(name)
      @poortego_session.session_values["Current Transform"] = obj
      @poortego_session.session_values["Current Selection Type"] = type
      @poortego_session.session_values["Current Object"] = @poortego_session.session_values["Current Transform"]
      @poortego_session.session_values["Current Dispatcher"] = 'TransformDispatcher'
    when 'entity'
      obj = PoortegoEntity.select_or_insert(@poortego_session.session_values["Current Project"].id, 
                                    @poortego_session.session_values["Current Section"].id, 
                                    name)
      @poortego_session.session_values["Current Entity"] = obj
      @poortego_session.session_values["Current Selection Type"] = type
      @poortego_session.session_values["Current Object"] = @poortego_session.session_values["Current Entity"]
      @poortego_session.session_values["Current Dispatcher"] = 'EntityDispatcher'
    when 'link'
      obj = PoortegoLink.select_or_insert(@poortego_session.session_values["Current Project"].id, 
                                  @poortego_session.session_values["Current Section"].id, 
                                  name)
      @poortego_session.session_values["Current Link"] = obj
      @poortego_session.session_values["Current Selection Type"] = type
      @poortego_session.session_values["Current Object"] = @poortego_session.session_values["Current Link"]
      @poortego_session.session_values["Current Dispatcher"] = 'LinkDispatcher'
    when 'entity_type'
      obj = PoortegoEntityType.select_or_insert(name)
      @poortego_session.session_values["Current EntityType"] = obj
      @poortego_session.session_values["Current Selection Type"] = type
      @poortego_session.session_values["Current Object"] = @poortego_session.session_values["Current EntityType"]
      @poortego_session.session_values["Current Dispatcher"] = 'EntityTypeDispatcher'
    when 'link_type'
      obj = PoortegoLinkType.select_or_insert(name)
      @poortego_session.session_values["Current LinkType"] = obj
      @poortego_session.session_values["Current Selection Type"] = type
      @poortego_session.session_values["Current Object"] = @poortego_session.session_values["Current LinkType"]
      @poortego_session.session_values["Current Dispatcher"] = 'LinkTypeDispatcher'  
    when 'field'
      if (@poortego_session.session_values["Current Selection Type"] == 'entity')
        obj = PoortegoEntityField.select_or_insert(@poortego_session.session_values["Current Entity"].id, name)
      elsif (@poortego_session.session_values["Current Selection Type"] == 'link')
        obj = PoortegoLinkField.select_or_insert(@poortego_session.session_values["Current Link"].id, name)
      elsif (@poortego_session.session_values["Current Selection Type"] == 'link_type')
        # Add a field to a Link Type
        obj = PoortegoLinkTypeField.select_or_insert(@poortego_session.session_values["Current LinkType"].id,
                                               name)  
      elsif (@poortego_session.session_values["Current Selection Type"] == 'entity_type')
        # Add a field to an Entity Type
        obj = PoortegoEntityTypeField.select_or_insert(@poortego_session.session_values["Current EntityType"].id,
                                               name)   
      end
    when 'descriptor'
      obj = PoortegoSectionDescriptor.select_or_insert(@poortego_session.session_values["Current Section"].id,
                                               name)
    else
      print_error("Invalid type: #{type}")
      return
    end
    
    if (obj.nil?)
      print_error("Invalid #{type} name, use list for list of valid #{type}s.")
      return   
    else
      #@poortego_session.session_values["Current Selection Type"] = type
      @poortego_session.update_default_type()
      print_status("Created #{type}, id #{obj.id}")
      set_prompt(driver)
    end
    
  end
  
  #
  # "Create" command help
  #
  def cmd_poortego_create_help(*args)
    print_status("Command    : create")
    print_status("Description: create a thing for manipulation.")
    print_status("Usage      : 'create [type] <name>'")
    print_status("Details    :")
    print_status("Where type is optional and name is required. Vaid types: project, section, transform, entity, link, entity_type, link_type, field, descriptor.")
    print_status("The default type is the current default type.")
  end
  
end
