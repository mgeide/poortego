class CMD_List
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
      list_objs = Project.list()
      tbl = Rex::Ui::Text::Table.new('Indent' => 4,
                                     'Columns' => ['id','title','description'])
      list_objs.each do |list_obj|
        tbl << [list_obj.id, list_obj.title, list_obj.description]
      end  
    when 'section', 'sections'        # List Section
      list_objs = Section.list(driver.interface.working_values["Current Project"].id)
      tbl = Rex::Ui::Text::Table.new('Indent' => 4,
                                     'Columns' => ['id','title','description'])
      list_objs.each do |list_obj|
        tbl << [list_obj.id, list_obj.title, list_obj.description]
      end 
    when 'transform', 'transforms'    # List Transform
      list_objs = Transform.list()
      tbl = Rex::Ui::Text::Table.new('Indent' => 4,
                                     'Columns' => ['id','title','description'])
      list_objs.each do |list_obj|
        tbl << [list_obj.id, list_obj.title, list_obj.description]
      end 
    when 'entity', 'entities'          # List Entity
      list_objs =  Entity.list(driver.interface.working_values["Current Project"].id, 
                               driver.interface.working_values["Current Section"].id)
      tbl = Rex::Ui::Text::Table.new('Indent' => 4,
                                     'Columns' => ['id','title','entity_type','description'])
      list_objs.each do |list_obj|
        entity_type_title = ''
        unless (list_obj.entity_type_id.nil?)
          if (list_obj.entity_type_id > 0)
            entity_type = EntityType.find(list_obj.entity_type_id)
            entity_type_title = entity_type.title
          end
        end
        tbl << [list_obj.id, list_obj.title, entity_type_title, list_obj.description]
      end 
    when 'link', 'links'              # List Links
      unless (driver.interface.working_values["Current Entity"].nil?)
        list_objs =  Link.list(driver.interface.working_values["Current Project"].id, 
                               driver.interface.working_values["Current Section"].id,
                               driver.interface.working_values["Current Entity"].id)
      else
        list_objs =  Link.list(driver.interface.working_values["Current Project"].id, 
                               driver.interface.working_values["Current Section"].id)
      end
                             
      tbl = Rex::Ui::Text::Table.new('Indent' => 4,
                                     'Columns' => ['id','entityA','entityB','title','description'])
      list_objs.each do |list_obj|
        entityA = Entity.find(list_obj.entity_a_id)
        entityB = Entity.find(list_obj.entity_b_id)
        tbl << [list_obj.id, entityA.title, entityB.title, list_obj.title, list_obj.description]
      end 
    when 'entity_type', 'entity_types'  # List Entity Types
      list_objs = EntityType.list()
      tbl = Rex::Ui::Text::Table.new('Indent' => 4,
                                     'Columns' => ['id','title','description'])
      list_objs.each do |list_obj|
        tbl << [list_obj.id, list_obj.title, list_obj.description]
      end 
    when 'link_type', 'link_types'  # List Link Types
      list_objs = LinkType.list()
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
  
  #
  # "List" command help
  #
  def cmd_list_help(*args)
    print_status("Command    : list")
    print_status("Description: displays list of things of a certain type.")
    print_status("Usage      : 'list [type]'")
    print_status("Details    :")
    print_status("Where type is optional. Vaid types: project(s), section(s), transform(s), entity(s), link(s), entity_type(s), link_type(s).")
    print_status("By default the type is the current default type.")
  end
  
  
  #
  # Tab completion for connect command
  #
  #def cmd_connect_tabs(str, words)
  #  return [] if words.length > 1
  #  res = %w{database help test}
  #  return res
  #end

end