class Poortego_Session

  attr_accessor :session_values 

  #
  # Constructor
  #
  def initialize()
    @session_values = Hash.new()
    initialize_session_values()
  end
  
  #
  # Initialize Working Values
  #
  def initialize_session_values() 
    @session_values["Current Dispatcher"]     = 'HomeDispatcher'
    @session_values["Current Selection Type"] = 'none'
    @session_values["Default Command Type"]   = 'project'
    @session_values["Current Object"]         = nil
    @session_values["Current Project"]        = nil
    @session_values["Current Section"]        = nil
    @session_values["Current Transform"]      = nil
    @session_values["Current Entity"]         = nil
    @session_values["Current Link"]           = nil
    @session_values["Current Descriptor"]     = nil
    @session_values["Current EntityType"]     = nil
    @session_values["Current LinkType"]       = nil

  end
  
  #
  # Get session values
  #
  def get_session_values()
    
    values = Hash.new()    
    @session_values.each do |key,value|
      values[key] = get_session_value(key)
    end
    
    return values
  end
  
  #
  # Get the session value variable
  #
  def get_session_value(*args)
    variable = args[0]
    
    if (@session_values[variable].nil?)
      return ""
    elsif (@session_values[variable].class.to_s == "String")
      return @session_values[variable]
    else
      return @session_values[variable].title
    end
    
  end
  
  #
  # Set the default object type to use for any run commands
  #
  def update_default_type()
    if (@session_values["Current Selection Type"] == 'none')
      @session_values["Default Command Type"] = 'project'
    elsif (@session_values["Current Selection Type"] == 'project')
      @session_values["Default Command Type"] = 'section'
    elsif (@session_values["Current Selection Type"] == 'section')
      @session_values["Default Command Type"] = 'entity'
    elsif (@session_values["Current Selection Type"] == 'entity')
      @session_values["Default Command Type"] = 'link'
    else
      @session_values["Default Command Type"] = @session_values["Current Selection Type"]    
    end
  end
  
  #
  # Move "back" based on the current selection type
  #
  def move_back()
    case @session_values["Current Selection Type"]
    when 'project'
      initialize_session_values()
    when 'section'      
      @session_values["Current Object"]         = @session_values["Current Project"]
      @session_values["Current Section"]        = nil
      @session_values["Current Selection Type"] = 'project'
    when 'entity'
      @session_values["Current Object"]         = @session_values["Current Section"]
      @session_values["Current Entity"]         = nil
      @session_values["Current Selection Type"] = 'section'
    else
      if (@session_values["Current Entity"].id > 0)        
        @session_values["Current Object"]         = @session_values["Current Entity"]
        @session_values["Current Transform"]      = nil
        @session_values["Current Link"]           = nil
        @session_values["Current Descriptor"]     = nil
        @session_values["Current EntityType"]     = nil
        @session_values["Current LinkType"]       = nil
        @session_values["Current Selection Type"] = 'entity'
      elsif (@session_values["Current Section"].id > 0) 
        @session_values["Current Object"]         = @session_values["Current Section"]
        @session_values["Current Transform"]      = nil
        @session_values["Current Entity"]         = nil
        @session_values["Current Link"]           = nil
        @session_values["Current Descriptor"]     = nil
        @session_values["Current EntityType"]     = nil
        @session_values["Current LinkType"]       = nil
        @session_values["Current Selection Type"] = 'section'
      elsif (@session_values["Current Project"].id > 0)
        @session_values["Current Object"]         = @session_values["Current Project"]
        @session_values["Current Section"]        = nil
        @session_values["Current Transform"]      = nil
        @session_values["Current Entity"]         = nil
        @session_values["Current Link"]           = nil
        @session_values["Current Descriptor"]     = nil
        @session_values["Current EntityType"]     = nil
        @session_values["Current LinkType"]       = nil
        @session_values["Current Selection Type"] = 'project'
      else
        initialize_session_values()
      end
    end
    update_default_type()
  end
  
end