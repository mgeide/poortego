#!/usr/bin/env ruby
#
# transform_shell.rb
#
###################




# Poortego::Console::CommandDispatcher
module Poortego
module Console
module CommandDispatcher

######################
# class: ProjectShell
######################  
class TransformDispatcher
  # Inherit from CommandDispatcher
  include Poortego::Console::CommandDispatcher
  
  @@commands = []
  
  ##########################
  # ProjectShell Constructor
  ########################## 
  def initialize(driver)
    super
    
    begin
      driver.interface.getcommands.each { |folder|
        folder['children'].each { |command|
          @@commands << folder['text'] + "/" + command['text'].gsub(/[-\(\)]/,"").gsub(/\W+/,"_")
        }
      }
    rescue
      return
    end
  end
  
  ########################
  # ProjectShell Commands
  ########################
  def commands
    {
      "show" => "Show the current project",
      "modify" => "Modify attributes of the current project",
      "section" => "Section manipulation",
    }
  end
  
  ###############################
  # ProjectShell Dispatcher Name
  ###############################
  def name
    "Transform"
  end
  

  def cmd_show(*args)
    if (driver.interface.current_selection == 'transform')
      transform_object = Transform.find(driver.interface.current_transform_id)
      
      tbl = Rex::Ui::Text::Table.new('Indent' => 4,
                                     'Columns' => ['Field',
                                                   'Value'   ])
      
      tbl << ["Id", transform_object.id]
      tbl << ["Title", transform_object.title]
      tbl << ["Description", transform_object.description]
      tbl << ["Created At", transform_object.created_at]
      tbl << ["Updated At", transform_object.updated_at]

      puts tbl.to_s + "\n"
      
    end
  end
  
  
end
  
end end end
