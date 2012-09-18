#module Poortego
#module Console
#module CommandDispatcher

#module ListCommand
module Commands
  
  #
  # "List" command logic
  #
  #  list [type]   (type is optional)    
  #
  def cmd_list(*args)
    # Default list type is the current default command type
    list_type = driver.interface.working_values["Default Command Type"]
    if (args.length == 1)
      list_type = args[0]
    elsif (args.length > 1)
      print_error("Ambiguous arguments.  Use -h if you need help.")
    end
    
    # Populate object names array with the contents to list
    list_objs = nil
    case list_type
    when '-h', '-?'       # List Help
        cmd_list_help
        return
    when 'project', 'projects'        # List Project
      list_objs = PoortegoProject.list()
      tbl = Rex::Ui::Text::Table.new('Indent' => 4,
                                     'Columns' => ['id','title','description'])
      list_objs.each do |list_obj|
        tbl << [list_obj.id, list_obj.title, list_obj.description]
      end  
    when 'section', 'sections'        # List Section
      list_objs = PoortegoSection.list(driver.interface.working_values["Current Project"].id)
      tbl = Rex::Ui::Text::Table.new('Indent' => 4,
                                     'Columns' => ['id','title','description'])
      list_objs.each do |list_obj|
        tbl << [list_obj.id, list_obj.title, list_obj.description]
      end 
    when 'transform', 'transforms'    # List Transform
      list_objs = PoortegoTransform.list()
      tbl = Rex::Ui::Text::Table.new('Indent' => 4,
                                     'Columns' => ['id','title','description'])
      list_objs.each do |list_obj|
        tbl << [list_obj.id, list_obj.title, list_obj.description]
      end 
    when 'entity', 'entities'          # List Entity
      list_objs =  PoortegoEntity.list(driver.interface.working_values["Current Project"].id, 
                               driver.interface.working_values["Current Section"].id)
      tbl = Rex::Ui::Text::Table.new('Indent' => 4,
                                     'Columns' => ['id','title','entity_type','description'])
      list_objs.each do |list_obj|
        entity_type_title = ''
        unless (list_obj.entity_type_id.nil?)
          if (list_obj.entity_type_id > 0)
            entity_type = PoortegoEntityType.find(list_obj.entity_type_id)
            entity_type_title = entity_type.title
          end
        end
        tbl << [list_obj.id, list_obj.title, entity_type_title, list_obj.description]
      end 
    when 'link', 'links'              # List Links
      unless (driver.interface.working_values["Current Entity"].nil?)
        list_objs =  PoortegoLink.list(driver.interface.working_values["Current Project"].id, 
                               driver.interface.working_values["Current Section"].id,
                               driver.interface.working_values["Current Entity"].id)
      else
        list_objs =  PoortegoLink.list(driver.interface.working_values["Current Project"].id, 
                               driver.interface.working_values["Current Section"].id)
      end
                             
      tbl = Rex::Ui::Text::Table.new('Indent' => 4,
                                     'Columns' => ['id','entityA','entityB','title','description'])
      list_objs.each do |list_obj|
        entityA = PoortegoEntity.find(list_obj.entity_a_id)
        entityB = PoortegoEntity.find(list_obj.entity_b_id)
        tbl << [list_obj.id, entityA.title, entityB.title, list_obj.title, list_obj.description]
      end 
    when 'entity_type', 'entity_types'  # List Entity Types
      list_objs = PoortegoEntityType.list()
      tbl = Rex::Ui::Text::Table.new('Indent' => 4,
                                     'Columns' => ['id','title','description'])
      list_objs.each do |list_obj|
        tbl << [list_obj.id, list_obj.title, list_obj.description]
      end 
    when 'link_type', 'link_types'  # List Link Types
      list_objs = PoortegoLinkType.list()
      tbl = Rex::Ui::Text::Table.new('Indent' => 4,
                                     'Columns' => ['id','title','description'])
      list_objs.each do |list_obj|
        tbl << [list_obj.id, list_obj.title, list_obj.description]
      end 
    else
      print_error("Invalid type argument passed to list command.")
      return                 
    end
    
    print_status("Listing #{list_type}(s) :")  
    puts "\n" + tbl.to_s + "\n"  
  end
  
  def cmd_list_help(*args)
    print_status("Command    : list")
    print_status("Description: displays list of things of a certain type.")
    print_status("Usage      : 'list [type]'")
    print_status("Details    :")
    print_status("Where type is optional. Vaid types: project(s), section(s), transform(s), entity(s), link(s), entity_type(s), link_type(s).")
    print_status("By default the type is the current default type.")
  end
  
  
end

#end end end