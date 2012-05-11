current_dir = File.expand_path(File.dirname(__FILE__))
require "#{current_dir}/CMD_functions"


###
#
# "linkto" Command - used from Entity dispatcher
#
###
class CMD_Linkto
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
  # Link current entity to another
  #
  def cmd_linkto(*args)
    project_id = driver.interface.working_values["Current Project"].id
    section_id = driver.interface.working_values["Current Section"].id
    entity_obj = driver.interface.working_values["Current Entity"]
    
    linkto_entity_name = args[0]
    if ((linkto_entity_name == '-h') || (linkto_entity_name == '-?'))
      cmd_linkto_help
      return
    end
    
    linkto_entity_obj = Entity.select(project_id, section_id, linkto_entity_name)
    if (linkto_entity_obj.nil?)
      if (linkto_entity_name =~ /^\d+$/)
        linkto_entity_obj = Entity.find(linkto_entity_name)
        if (linkto_entity_obj.nil?)
          print_error("Unable to build link to: #{linkto_entity_name}")
          return
        end
      end
    end
    
    link_name = driver.interface.working_values["Current Entity"].title + " --> " + linkto_entity_obj.title
    link_obj = Link.select_or_insert(project_id, section_id, entity_obj.title, linkto_entity_obj.title, link_name)    
        
    unless (link_obj.nil?)
      driver.interface.working_values["Current Link"] = link_obj
      driver.interface.working_values["Current Object"] = driver.interface.working_values["Current Link"]
      driver.interface.working_values["Current Selection Type"] = 'link'
      driver.interface.working_values["Current Dispatcher"] = "LinkDispatcher"
      set_prompt(driver)
    else
      print_error("Unable to build link to: #{link_name}")
    end  
  end
  
  #
  # "linkto" command help
  #
  def cmd_linkto_help
    print_status("Command    : linkto")
    print_status("Description: link the current entity to another.")
    print_status("Usage      : 'linkto <entity>'")
  end
  
end