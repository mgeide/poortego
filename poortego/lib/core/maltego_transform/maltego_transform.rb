#==========================================================================================#
# MaltegoTransform
#
# This class represent a Transform in Maltego
#
# Author:: Robert McArdle (RobertMcArdle@gmail.com)
# First Added:: v0.2
# Last Changed:: v0.2
#
#==========================================================================================#
require File.join(File.expand_path(File.dirname(__FILE__)),"maltego_entity.rb") #Import Maltego_Entities (Cross-Platform)
#==========================================================================================#

class MaltegoTransform
  #=Declaring instance variables
  # * resultEntities - An array of resulting Maltego Entities
  # * exceptions - An array of raised exceptions
  # * uiMessages - An array of UI Messages to display
  # * entityFields - the Value and Fields of the calling entity
  #
  # NOTE: I have not included "set" and "get" methods here - you can simply use the variable directly e.g.
  #   example = MaltegoTransform()
  #   example.exception << myException
  # This also means there is deliberately no error checking (e.g. is the Weight a numerical number)
  attr_accessor :resultEntities, :exceptions, :uiMessages, :entityFields

  #==========================================================================================#

  #Constructor for a MaltegoTransform
  # First Added: v0.2
  # Last Changed: v0.2
  #Parameters
  #  none
  def initialize(*args)
    @resultEntities = Array.new()
    @exceptions     = Array.new()
    @uiMessages     = Array.new()
    @entityFields   = Hash.new()
    parseArguments(args)
  end

  #==========================================================================================#

  #Method to parse the arguments passed to the Transform into the @entityFields variable
  # First Added: v0.2
  # Last Changed: v0.2
  #Parameters
  #  none
  def parseArguments(*args)
    if args.length == 0
      addException("ERROR: Zero Parameters passed to Transform")
      throwException()
    end
    if args[0] != nil
      @entityFields['entityValue'] = args[0]
    end
    #Read in any Additional Fields
    if args.length > 1
      args[1].to_s.split('#').each do |otherparam|
        result = otherparam.split('=')
        @entityFields[result[0]] = result[1]
      end
    end
  end

  #==========================================================================================#

  #Method to create an Entity, add it to the Transform results, and return it to the user
  # First Added: v0.2
  # Last Changed: v0.2
  #Parameters
  #  string entityType - Type of Entity e.g. Phrase
  #  string value - Value of the entity
  #Returns
  #  MaltegoEntity - A handle to the added MaltegoEntity
  def addEntity(entityType, value)
    newEntity = MaltegoEntity.new(entityType,value)
    addEntityToMessage(newEntity)
    return @resultEntities.last #Return the last added Entity
  end

  #==========================================================================================#

  #Method to add a MaltegoEntity to the Transform results
  # First Added: v0.2
  # Last Changed: v0.2
  #Parameters
  #  MaltegoEntity newEntity - MaltegoEntity to append
  def addEntityToMessage(newEntity)
    @resultEntities << newEntity
  end

  #==========================================================================================#

  #Method to add a UI Message to the Transform output
  # First Added: v0.2
  # Last Changed: v0.2
  #Parameters
  #  string message - Message to display
  #  string messageType - Type of message. Can be FatalError, PartialError, Inform (default) or Debug
  def addUIMessage(message, messageType="Inform")
    uiMessage = Hash.new()
    if ["FatalError","PartialError","Inform","Debug"].include?(messageType) #If allowed message type
      uiMessage['message'] = message
      uiMessage['messageType'] = messageType
    else
      #Output an Error
      uiMessage['message'] = "UIMessage created with invalid message type. Original Message: #{message}. Original MessageType: #{messageType}"
      uiMessage['messageType'] = "PartialError"
    end
    @uiMessages << uiMessage
  end

  #==========================================================================================#

  #Method to add an Exception to the Transform output
  # First Added: v0.2
  # Last Changed: v0.2
  #Parameters
  #  string exceptionString - Exception to Raise
  def addException(exceptionString)
    @exceptions << exceptionString
  end

  #==========================================================================================#

  #Method to "throw" an Exception i.e. Write it in the Transform output and exit
  #This is only to be used where a major error occured in the code that could not be handled
  # First Added: v0.2
  # Last Changed: v0.2
  #Parameters
  #  none
  def throwException()
    puts "<MaltegoMessage>"
    puts "<MaltegoTransformExceptionMessage>"
    puts "<Exceptions>"
    @exceptions.each do |exception|
      puts "<Exception>#{exception}</Exception>"
    end
    puts "</Exceptions>"
    puts "</MaltegoTransformExceptionMessage>"
    puts "</MaltegoMessage>"
    exit()
  end

  #==========================================================================================#

  #Method to write a message to Standard Error. Mostly called by progress(), debug(), etc
  # First Added: v0.2
  # Last Changed: v0.2
  #Parameters
  #  string message - Message to write
  def writeSTDERR(message)
    $stderr.puts(message)
  end

  #==========================================================================================#

  #Method to print progress as a percentage in the GUI
  # First Added: v0.2
  # Last Changed: v0.2
  #Parameters
  #  integer percent - Progress percentage
  def progress(percent)
    writeSTDERR("%#{percent}")
  end

  #==========================================================================================#

  #Method to write a debug message to the Maltego GUI (which will only show up if debugging is enabled on the Transform)
  # First Added: v0.2
  # Last Changed: v0.2
  #Parameters
  #  string message - Message to write
  def debug(message)
    writeSTDERR("D:#{message}")
  end

  #==========================================================================================#

  #This method is also implemented in Python and PHP Maltego libraries, so I added it as well
  # First Added: v0.2
  # Last Changed: v0.2
  #Parameters
  #  none
  def heartbeat()
    writeSTDERR("+")
  end

  #==========================================================================================#

  #This method returns the transform Output in XML
  # First Added: v0.2
  # Last Changed: v0.2
  #Parameters
  #  none
  def returnOutput()
    result = "<MaltegoMessage>\n"
    result.concat("<MaltegoTransformResponseMessage>\n")
    #Add Entities
    result.concat("<Entities>\n")
    @resultEntities.each do |entity|
      result.concat(entity.returnEntity())
    end
    result.concat("</Entities>\n")
    #Add UI Messages
    result.concat("<UIMessages>\n")
    @uiMessages.each do |uiMessage|
      result.concat("<UIMessage MessageType=\"#{uiMessage['messageType']}\">#{uiMessage['message']}</UIMessage>\n")
    end
    result.concat("</UIMessages>\n")
    result.concat("</MaltegoTransformResponseMessage>\n")
    result.concat("</MaltegoMessage>\n")
  end

  #==========================================================================================#

  #A method to print the Transform output as XML to STDOUT
  # First Added: v0.2
  # Last Changed: v0.2
  #Parameters
  #  none
  def printOutput()
    #Simply print the XML to Standard Out.
    puts returnOutput()
  end

  #==========================================================================================#
end
