

###
#
#  PoortegoTransformEntity Class
#
###
class PoortegoTransformEntity
  attr_accessor :attributes, :additionalFields
  
  #
  # Constructor
  #
  def initialize(*args)
    @attributes       = Hash.new()  # Hash of attribute key => value pairs
    @additionalFields = Hash.new()  # Hash of field name => value pairs
    
    if ( (args.length == 2) &&
         (args[0].class.to_s == 'Hash') && 
         (args[1].class.to_s == 'Hash') )
         
         @attributes = args[0]
         @additionalFields = args[1]
    else
      ## TODO: raise exception
      puts "ERROR in poortego_transform_entity constructor"
    end
  end
 
  #
  # setAttribute
  #
  def setAttribute(key, value)
    @attributes[key] = value
  end
  
  #
  # setField
  #
  def setField(name, value)
    @additionalFields[name] = value
  end
  
end