###
#
# Dispatcher for "project" commands
#
###

module Poortego
module Console
module CommandDispatcher

###
# 
# Project Dispatcher Class
#
###  
class EntityTypeDispatcher
  
  # Inherit from CommandDispatcher
  include Poortego::Console::CommandDispatcher
  
  #
  # Constructor
  # 
  def initialize(driver)
    super
  end
  
  #
  # Support These Commands
  #
  def commands
    {
      "add" => "Add a field to the type",
      "remove" => "Remove a field from the type",
      "fields" => "Show fields associated with the type"
    }
  end
  
  #
  # Dispatcher Name
  #
  def name
    "EntityType"
  end
  
  def cmd_add(*args)
     field_name = args[0]
     type_id = driver.interface.working_values["Current EntityType"].id
     
     id = EntityTypeField.select_or_insert(type_id, field_name)
  end
  
  def cmd_remove(*args)
     field_name = args[0]
     type_id = driver.interface.working_values["Current EntityType"].id
     
     id = EntityTypeField.delete_from_name(type_id, field_name)
  end

  def cmd_fields(*args)
     
    type_id = driver.interface.working_values["Current EntityType"].id
     
    list_names = EntityTypeField.list(type_id)
    
    # Build table of listing with 4 columns 
    tbl = Rex::Ui::Text::Table.new('Indent' => 4,
                                   'Columns' => ['','','',''])
    col_num = 0
    row_array = Array.new()
      
    list_names.each do |list_name|
      if (col_num > 3)
        tbl << row_array
        row_array = Array.new()
        col_num = 0
      end
      row_array << list_name
      col_num = col_num + 1  
    end  # End of table loop
      
    if (col_num > 0)
      while (col_num <= 3)
        row_array << ''
        col_num = col_num + 1
      end
      tbl << row_array
    end  # End of table completion
      
    puts tbl.to_s + "\n"  
  end
  
end
  
end end end
