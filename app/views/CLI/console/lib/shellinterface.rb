
#
# This is the place to shove stuff that is going to be shared between dispatchers
#

module Poortego 
module Console

class ShellInterface
  
  #
  # ShellInterface Constructor
  #
  def initialize()
    self.initialize_working_values()
  end
  
  #
  # Initialize Working Values
  #
  def initialize_working_values()
    
    # Define a Hash containing the current working values
    self.working_values = Hash.new()
    self.working_values["Current Selection Type"] = 'none'
    self.working_values["Default Command Type"]   = 'project'
    self.working_values["Current Object"]         = nil
    self.working_values["Current Project"]        = nil
    self.working_values["Current Section"]        = nil
    self.working_values["Current Transform"]      = nil
    self.working_values["Current Entity"]         = nil
    self.working_values["Current Link"]           = nil
    self.working_values["Current Descriptor"]     = nil
    self.working_values["Current EntityType"]     = nil
    self.working_values["Current LinkType"]       = nil

  end
  
  #
  # Get working values
  #
  def get_working_values()
    
    values = Hash.new()    
    self.working_values.each do |key,value|
      values[key] = self.get_working_value(key)
    end
    
    return values
  end
  
  #
  # Get the working value variable
  #
  def get_working_value(*args)
    variable = args[0]
    
    if (self.working_values[variable].nil?)
      return ""
    elsif (self.working_values[variable].class.to_s == "String")
      return self.working_values[variable]
    else
      return self.working_values[variable].title
    end
    
  end
  
  #
  # Set the default object type to use for any run commands
  #
  def update_default_type()
    if (self.working_values["Current Selection Type"] == 'none')
      self.working_values["Default Command Type"] = 'project'
    elsif (self.working_values["Current Selection Type"] == 'project')
      self.working_values["Default Command Type"] = 'section'
    elsif (self.working_values["Current Selection Type"] == 'section')
      self.working_values["Default Command Type"] = 'entity'
    elsif (self.working_values["Current Selection Type"] == 'entity')
      self.working_values["Default Command Type"] = 'link'
    else
      self.working_values["Default Command Type"] = self.working_values["Current Selection Type"]    
    end
  end
  
  #
  # Move "back" based on the current selection type
  #
  def move_back()
    case self.working_values["Current Selection Type"]
    when 'project'
      self.initialize_working_values()
    when 'section'      
      self.working_values["Current Object"]         = self.working_values["Current Project"]
      self.working_values["Current Section"]        = nil
      self.working_values["Current Selection Type"] = 'project'
    when 'entity'
      self.working_values["Current Object"]         = self.working_values["Current Section"]
      self.working_values["Current Entity"]         = nil
      self.working_values["Current Selection Type"] = 'section'
    else
      if (self.current_entity_id > 0)        
        self.working_values["Current Object"]         = self.working_values["Current Entity"]
        self.working_values["Current Transform"]      = nil
        self.working_values["Current Link"]           = nil
        self.working_values["Current Descriptor"]     = nil
        self.working_values["Current EntityType"]     = nil
        self.working_values["Current LinkType"]       = nil
        self.working_values["Current Selection Type"] = 'entity'
      elsif (self.current_section_id > 0) 
        self.working_values["Current Object"]         = self.working_values["Current Section"]
        self.working_values["Current Transform"]      = nil
        self.working_values["Current Entity"]         = nil
        self.working_values["Current Link"]           = nil
        self.working_values["Current Descriptor"]     = nil
        self.working_values["Current EntityType"]     = nil
        self.working_values["Current LinkType"]       = nil
        self.working_values["Current Selection Type"] = 'section'
      elsif (self.current_project_id > 0)
        self.working_values["Current Object"]         = self.working_values["Current Project"]
        self.working_values["Current Section"]        = nil
        self.working_values["Current Transform"]      = nil
        self.working_values["Current Entity"]         = nil
        self.working_values["Current Link"]           = nil
        self.working_values["Current Descriptor"]     = nil
        self.working_values["Current EntityType"]     = nil
        self.working_values["Current LinkType"]       = nil
        self.working_values["Current Selection Type"] = 'project'
      else
        initialize_working_values()
      end
    end
    update_default_type()
  end
  
  attr_accessor :working_values
  
end

end end
