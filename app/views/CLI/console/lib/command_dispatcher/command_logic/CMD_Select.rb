current_dir = File.expand_path(File.dirname(__FILE__))
require "#{current_dir}/CMD_functions"

###
#
# Select Command Class
#
###
class CMD_Select
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
  # Select logic
  #
  def cmd_select(*args)
    type = ''
    name = '' 
    obj  = nil 
     
    if (args.length == 1)
      type = driver.interface.working_values["Default Command Type"]
      name = args[0]
    elsif (args.length == 2)
      type = args[0]
      name = args[1]
    else    
      print_error("Invalid number of arguments passed to select command.")
      cmd_select_help
      return
    end
  
    case type
    when '-h', '-?' 
      cmd_select_help
      return
    when 'project'
      if (name =~ /^\d+$/) # ID
        obj = Project.find(name)
      else
        obj = Project.select(name)
      end
      driver.interface.working_values["Current Project"] = obj
      driver.interface.working_values["Current Object"]  = driver.interface.working_values["Current Project"]
      driver.interface.working_values["Current Dispatcher"] = 'ProjectDispatcher'
    when 'section'
      if (name =~ /^\d+$/)
        obj = Section.find(name)
      else
        obj = Section.select(driver.interface.working_values["Current Project"].id, name)
      end
      driver.interface.working_values["Current Section"] = obj
      driver.interface.working_values["Current Object"] = driver.interface.working_values["Current Section"]
      driver.interface.working_values["Current Dispatcher"] = 'SectionDispatcher'
    when 'transform'
      if (name =~ /^\d+$/)
        obj = Transform.find(name)
      else
        obj = Transform.select(name)
      end
      driver.interface.working_values["Current Transform"] = obj
      driver.interface.working_values["Current Object"] = driver.interface.working_values["Current Transform"]
      driver.interface.working_values["Current Dispatcher"] = 'TransformDispatcher'
    when 'entity'
      if (name =~ /^\d+$/)
        obj = Entity.find(name)
      else
        obj = Entity.select(driver.interface.working_values["Current Project"].id, 
                            driver.interface.working_values["Current Section"].id, 
                            name)
      end
      driver.interface.working_values["Current Entity"] = obj
      driver.interface.working_values["Current Object"] = driver.interface.working_values["Current Entity"]
      driver.interface.working_values["Current Dispatcher"] = 'EntityDispatcher'
    when 'link'
      if (name =~ /^\d+$/)
        obj = Link.find(name)
      else
        obj = Link.select_by_name(driver.interface.working_values["Current Project"].id, 
                                  driver.interface.working_values["Current Section"].id, 
                                  name)
      end
      driver.interface.working_values["Current Link"] = obj
      driver.interface.working_values["Current Object"] = driver.interface.working_values["Current Link"]
      driver.interface.working_values["Current Dispatcher"] = 'LinkDispatcher'
    when 'entity_type'
      if (name =~ /^\d+$/)
        obj = EntityType.find(name)
      else
        obj = EntityType.select(name)
      end
      driver.interface.working_values["Current EntityType"] = obj
      driver.interface.working_values["Current Object"] = driver.interface.working_values["Current EntityType"]
      driver.interface.working_values["Current Dispatcher"] = 'EntityTypeDispatcher'
    when 'link_type'
      if (name =~ /^\d+$/)
        obj = LinkType.find(name)
      else
        obj = LinkType.select(name)
      end
      driver.interface.working_values["Current LinkType"] = obj
      driver.interface.working_values["Current Object"] = driver.interface.working_values["Current LinkType"]
      driver.interface.working_values["Current Dispatcher"] = 'LinkTypeDispatcher'  
    else
      print_error("Invalid type: #{type}")
      return
    end
    
    #if (id < 1)
    if (obj.nil?)
      print_error("Invalid #{type} name, use list for list of valid #{type}s.")
      return   
    else
      driver.interface.working_values["Current Selection Type"] = type
      driver.interface.update_default_type()
      print_status("Selected #{type}, id #{obj.id}")
      set_prompt(driver)
    end
  end
  
  #
  # Select Help
  #
  def cmd_select_help(*args)
    print_status("Command    : select")
    print_status("Description: select a thing for manipulation.")
    print_status("Usage      : 'select [type] <name>'")
    print_status("Details    :")
    print_status("Where type is optional and name is required. Vaid types: project, section, transform, entity, link, entity_type, link_type.")
    print_status("The default type is the currently default type.")
  end
  
end