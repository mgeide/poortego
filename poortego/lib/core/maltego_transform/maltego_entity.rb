#==========================================================================================#
# MaltegoEntity
#
# This class represent an Entity in Maltego
#
# Author:: Robert McArdle (RobertMcArdle@gmail.com)
# First Added:: v0.2
# Last Changed:: v0.2
#
#==========================================================================================#

class MaltegoEntity
  #=Declaring instance variables
  # * value - The displayed value of the Maltego entity
  # * weight - All Maltego entities have a weight. The default will be set to 100
  # * displayInformation - Display Information if for providing additional information to the user about the entity (HTML)
  # * additionalFields - An array of additional info on the object, which is also passed in Transforms
  # * iconURL - A custom Icon for the Entity
  # * entityType - Type of entity. Default is ""Phrase"
  #
  # NOTE: I have not included "set" and "get" methods here - you can simply use the variable directly e.g.
  #   example = MaltegoEntity(nil,nil)
  #   example.value = "MyValue"
  # This also means there is deliberately no error checking (e.g. is the Weight a numerical number)
  # The exception is additionalFields, which needs its own method
  attr_accessor :value, :weight, :displayInformation, :additionalFields, :iconURL, :entityType

  #==========================================================================================#

  #Constructor for a MaltegoEntity
  # First Added: v0.2
  # Last Changed: v0.2
  #Parameters
  #  string entityType - Type of Entity e.g. Phrase
  #  string value - Value of the entity
  def initialize(entityType=nil, value=nil)
    #Store Entity Type
    if entityType != nil
      @entityType = entityType  #NOTE: We do not sanity check that it is a known type, for scalability
    else
      @entityType = "Phrase" #DEFAULT: Phrase type
    end
    #Store Entity Value
    if value != nil
      @value = value
    else
      @value = "" #Blank Initialisation
    end
    #Setup other instance variables
    @weight = 100
    @displayInformation = ""
    @additionalFields = Array.new()
    @iconURL = ""
  end

  #==========================================================================================#

  #A method to add an additional field
  # First Added: v0.2
  # Last Changed: v0.2
  #Parameters
  #  string fieldName - Name of field as it will be passed in parameters
  #  string displayName - Name of the field as it will be displayed in the GUI
  #  string matchingRule - Matching can be either strict, loose or nil (omitted). See Maltego docs
  #  string value - Contents of the field
  #Return
  #  false - if fieldName is not specified (this is mandatory for Maltego)
  def addAdditionalFields(fieldName=nil, displayName=nil, matchingRule=nil, value=nil)
    additionalField = Hash.new()
    if fieldName!=nil #FieldName is the only mandatory field
      additionalField['FieldName'] = fieldName
    else
      return false
    end
    additionalField['DisplayName'] = displayName
    additionalField['MatchingRule'] = matchingRule
    additionalField['Value'] = value
    @additionalFields << additionalField
  end

  #==========================================================================================#

  #A method to return the entity as XML
  # First Added: v0.2
  # Last Changed: v0.2
  #Parameters
  #  none
  #Returns
  #  XML of the Entity
  def returnEntity()
    result = "<Entity Type=\"#{@entityType}\">\n"
    result.concat("<Value>#{@value}</Value>\n")
    result.concat("<Weight>#{@weight}</Weight>\n")
    #Add Display Info if present
    if @displayInformation.length > 0
      result.concat("<DisplayInformation><Label Name=\"\" Type=\"text/html\"><![CDATA[#{@displayInformation}]]></Label></DisplayInformation>\n")
    end
    #Add Additional Field if present
    if @additionalFields.length > 0
      result.concat("<AdditionalFields>\n")
      @additionalFields.each do |additionalField|
        if additionalField['MatchingRule'] == nil
          result.concat("<Field Name=\"#{additionalField['FieldName']}\" DisplayName=\"#{additionalField['DisplayName']}\">#{additionalField['Value']}</Field>\n")
        else
          result.concat("<Field MatchingRule=\"#{additionalField['MatchingRule']}\" Name=\"#{additionalField['FieldName']}\" DisplayName=\"#{additionalField['DisplayName']}\">#{additionalField['Value']}</Field>\n")
        end
      end
      result.concat("</AdditionalFields>\n")
    end
    if @iconURL.length > 0
      result.concat("<IconURL>#{@iconURL}</IconURL>\n")
    end
    result.concat("</Entity>\n")
    return result
  end

  #==========================================================================================#

  #A method to print the entity as XML to STDOUT
  # First Added: v0.2
  # Last Changed: v0.2
  #Parameters
  #  none
  def printEntity()
    #Simply print the XML to Standard Out.
    puts returnEntity()
  end

  #==========================================================================================#
end
