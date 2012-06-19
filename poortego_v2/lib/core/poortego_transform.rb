
current_dir = File.expand_path(File.dirname(__FILE__))
require "#{current_dir}/poortego_transform/poortego_transform_message.rb"
require "#{current_dir}/poortego_transform/poortego_transform_entity.rb"
require "#{current_dir}/poortego_transform/poortego_transform_link.rb"


####
#
# PoortegoTransform
#
###
class PoortegoTransform
  attr_accessor :transformInput, :responseMessages, :responseEntities, :responseLinks
  
  #
  # Constructor
  #
  def initialize(*args)
    # Variables and their storage format
    @transformInput   = Hash.new()  # Tag => Value 
    @responseMessages = Array.new() # Array of PoortegoTransformMessage
    @responseEntities = Array.new() # Array of PoortegoTransformEntity
    @responseLinks    = Array.new() # Array of PoortegoTransformLink
    
    ## Parse and store input into transform
    parseInput(args)
  end
  
  #
  # Parse Input into Transform
  #
  def parseInput(*args)
    ## One argument input (entityValue)
    if (args.length == 1)
      @transformInput['entityValue'] = args[0]
    ## Two argument input (entityValue additionalData#Delimited)
    elsif (args.length == 2)
      @transformInput['entityValue'] = args[0]
      args[1].to_s.split('#').each do |otherparam|
        result = otherparam.split('=')
        if (result.length == 1)
          @transformInput[result[0]] = ''
        elsif (result.length == 2)
          @transformInput[result[0]] = result[1]
        else
          addMessage("Exception", "ERROR: error parsing second argument into transform (#{otherparam}).")
          throwException()
        end
      end
    else  ## Invalid number of arguments
      addMessage("Exception", "ERROR: Invalid number of parameters passed to transform (#{args.length} arguments).")
      throwException()
    end
  end
  
  #
  # addMessage
  #
  def addMessage(title, type, body)
    message = PoortegoTransformMessage.new(title, type, body)
    @responseMessages << message
    return @responseMessages.last
  end
  
  #
  # addEntity
  #
  def addEntity(attributeHash, fieldHash)
    entity = PoortegoTransformEntity.new(attributeHash, fieldHash)
    @responseEntities << entity
    return @responseEntities.last
  end
  
  #
  # addLink
  #
  def addLink(attributeHash, fieldHash)
    link = PoortegoTransformLink.new(attributeHash, fieldHash)
    @responseLinks << link
    return @responseLinks.last
  end

  #
  # throwException
  #
  def throwException()
    exit()
  end
  
end
