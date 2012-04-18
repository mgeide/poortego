###
#
# Dispatcher for "section" commands
#
###

module Poortego
module Console
module CommandDispatcher

###
#
# Section Dispatcher Class
#
###  
class SectionDispatcher
  
  # Inherit from CommandDispatcher
  include Poortego::Console::CommandDispatcher
    
  #
  # Constructor
  #
  def initialize(driver)
    super
  end
  
  #
  # Support these commands
  #
  def commands
    {
      "descriptor"      => "Manipulate Section Descriptor",  ## TODO
      "link"            => "Create a link between two entities", ## TODO
    }
  end
  
  #
  # Dispatcher name
  #
  def name
    "Section"
  end
  
  #
  # "Link" command logic
  #
  #  link <objA> <objB>
  #
  def cmd_link(*args)
    
    if (args.length != 2)
      cmd_link_help
      return
    end

    objA_name  = args[0]
    objB_name  = args[1]
    link_name  = "#{objA_name} --> #{objB_name}"  ## Default link name: "obJA --> objB"
    
    link_obj = Link.select_or_insert(driver.interface.working_values["Current Project"], 
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
  
  #
  # "Descriptor" command logic
  #
  #  descriptor [[[action] [name]] [value]]
  #
  def cmd_descriptor(*args)
    
    section_id = driver.interface.working_values["Current Section"].id
    descriptor_action = nil
    descriptor_name   = nil
    
    if (args.length < 1)
      descriptor_action = list  # Default action
    else 
      descriptor_action = args[0] # list, set, add, remove
      if (args.length >= 2)
        descriptor_name = args[1]
      end
    end
    
    case descriptor_action
    when '-?', '-h'
      cmd_descriptor_help
      return
    when 'list'
      print_status("Listing descriptors for section:")  
      descriptor_objs = SectionDescriptor.list(section_id)
      descriptor_objs.each {|descriptor_obj|
       puts "#{descriptor_obj.field_name}  |  #{descriptor_obj.value}"  
      }
    when 'set'
      descriptor_value = args[2]  # Value to set for descriptor
      descriptor_obj   = SectionDescriptor.select_or_insert(section_id, descriptor_name)
      descriptor_obj.update_attributes(:value => descriptor_value)
      descriptor_obj.save
      print_status("SectionDescriptor #{descriptor_name} set to #{descriptor_value}")    
    when 'add'
      SectionDescriptor.select_or_insert(section_id, descriptor_name)
      print_status("Sectionescriptor #{descriptor_name} added.")  ## TODO: add error checking
    when 'remove'
      SectionDescriptor.delete_from_name(section_id, descriptor_name)
      print_status("SectionDescriptor #{descriptor_name} removed.")  ## TODO: add error checking
    else
      print_error("Invalid action.")      
    end  
    
  end
  
  #
  # "Descriptor" command help
  #
  def cmd_descriptor_help(*args)
    print_status("Command    : descriptor")
    print_status("Description: manipulate the descriptors for the currently select section.")
    print_status("Usage      : 'descriptor [[action [name [value]]]'")
    print_status("Details    :")
    print_status("Where all arguments are optional. Vaid actions: add, remove, set, list.")
    print_status("By default the action is list. A value is needed only if the set action is used.")
  end
  
end # End Class
  
end end end  # End Modules
