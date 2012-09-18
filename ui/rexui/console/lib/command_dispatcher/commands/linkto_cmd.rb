
current_dir = File.expand_path(File.dirname(__FILE__))
require "#{current_dir}/helper_functions"

module PoortegoCommands
  
  #
  # Link current entity to another
  #
  def cmd_poortego_linkto(*args)
    project_id = @poortego_session.session_values["Current Project"].id
    section_id = @poortego_session.session_values["Current Section"].id
    entity_obj = @poortego_session.session_values["Current Entity"]
    
    linkto_entity_name = args[0]
    if ((linkto_entity_name == '-h') || (linkto_entity_name == '-?'))
      cmd_poortego_linkto_help
      return
    end
    
    linkto_entity_obj = PoortegoEntity.select(project_id, section_id, linkto_entity_name)
    if (linkto_entity_obj.nil?)
      if (linkto_entity_name =~ /^\d+$/)
        linkto_entity_obj = PoortegoEntity.find(linkto_entity_name)
        if (linkto_entity_obj.nil?)
          print_error("Unable to build link to: #{linkto_entity_name}")
          return
        end
      end
    end
    
    link_name = @poortego_session.session_values["Current Entity"].title + " --> " + linkto_entity_obj.title
    link_obj = PoortegoLink.select_or_insert(project_id, section_id, entity_obj.title, linkto_entity_obj.title, link_name)    
        
    unless (link_obj.nil?)
      @poortego_session.session_values["Current Link"] = link_obj
      @poortego_session.session_values["Current Object"] = @poortego_session.session_values["Current Link"]
      @poortego_session.session_values["Current Selection Type"] = 'link'
      @poortego_session.session_values["Current Dispatcher"] = "LinkDispatcher"
      set_prompt(driver)
    else
      print_error("Unable to build link to: #{link_name}")
    end  
  end
  
  #
  # "linkto" command help
  #
  def cmd_poortego_linkto_help
    print_status("Command    : linkto")
    print_status("Description: link the current entity to another.")
    print_status("Usage      : 'linkto <entity>'")
  end
  
end

