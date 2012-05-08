class CMD_Delete
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
  # "Delete" command logic
  #  delete [type] <name>
  #
  def cmd_delete(*args)
    
    type = ''
    name = '' 
    obj  = nil
     
    if (args.length == 1)
      type = driver.interface.working_values["Default Command Type"]
      name = args[0]
      if ((name == '-?') || (name == '-h'))
        cmd_delete_help
        return
      end
    elsif (args.length == 2)
      type = args[0]
      name = args[1]
    else    
      print_error("Invalid number of arguments passed to delete command.")
      cmd_delete_help
      return
    end  
    
    case type
    when '-h', '-?' 
      cmd_delete_help
      return
    when 'project'
      if (name =~ /^\d+$/)
        obj = Project.delete(name)
      else
        obj = Project.delete_from_name(name)
      end 
    when 'section'
      if (name =~ /^\d+$/)
        obj = Section.delete(name)
      else
        obj = Section.delete_from_name(driver.interface.working_values["Current Project"].id, name)
      end
    when 'transform'
      if (name =~ /^\d+$/)
        obj = Transform.delete(name)
      else  
        obj = Transform.delete_from_name(name)
      end
    when 'entity'
      if (name =~ /^\d+$/)
        obj = Entity.delete(name)
      else
        obj = Entity.delete_from_name(driver.interface.working_values["Current Project"].id, 
                                      driver.interface.working_values["Current Section"].id, 
                                      name)
      end
    when 'link'
      if (name =~ /^\d+$/)
        obj = Link.delete(name)
      else
        obj = Link.delete_from_name(driver.interface.working_values["Current Project"].id, 
                                    driver.interface.working_values["Current Section"].id, 
                                    name)
      end
    when 'descriptor'
      if (name =~ /^\d+$/)
        obj = SectionDescriptor.delete(name)
      else
        obj = SectionDescriptor.delete_from_name(driver.interface.working_values["Current Section"].id, 
                                                 name)
      end
    when 'field'
      if (driver.interface.working_values["Current Selection Type"] == 'entity')
        if (name =~ /^\d$/)
          obj = EntityField.delete(name)
        else
          obj = EntityField.delete_from_name(driver.interface.working_values["Current Entity"].id,
                                             name)
        end
      elsif (driver.interface.working_values["Current Selection Type"] == 'link')
        if (name =~ /^\d$/)
          obj = LinkField.delete(name)
        else
          obj = LinkField.delete_from_name(driver.interface.working_values["Current Link"].id,
                                           name)
        end
      elsif (driver.interface.working_values["Current Selection Type"] == 'link_type')
        # Remove field from link type
        obj = LinkTypeField.delete_from_name(driver.interface.working_values["Current LinkType"].id,
                                             name)
      elsif (driver.interface.working_values["Current Selection Type"] == 'entity_type')
        # Remove field from entity type
        obj = EntityTypeField.delete_from_name(driver.interface.working_values["Current EntityType"].id,
                                             name)  
      else
        print_error("Invalid: type #{type} does not have field.")
        return
      end
    when 'entity_type'
      if (name =~ /^\d$/)
        obj = EntityType.delete(name)
      else
        obj = EntityType.delete_from_name(name)
      end
    when 'link_type'
      if (name =~ /^\d$/)
        obj = LinkType.delete(name)
      else
        obj = LinkType.delete_from_name(name)
      end  
    else
      print_error("Invalid type")
      return
    end
    
    if (obj.nil?)
      print_error("Invalid #{type} name, use list for list of valid #{type}s.")
      return
    else
      if (obj.class.to_s == 'Fixnum')
        print_status("Deleted #{type}, id #{name}")
      else
        print_status("Deleted #{type}, id #{obj.id}")
      end
    end 
    
    ## TODO prevent from happening or update prompt if current thing is deleted
    
  end
  
  #
  # "Delete" command help
  #
  def cmd_delete_help(*args)
    print_status("Command    : delete")
    print_status("Description: delete a thing.")
    print_status("Usage      : 'delete [type] <name>'")
    print_status("Details    :")
    print_status("Where type is optional and name is required. Vaid types: project, section, descriptor, transform, entity, link, entity_type, link_type.")
    print_status("The default type is the current default command type.")
  end

end