
require 'rubygems'
require 'xml'
require 'libxml'
require 'xmlsimple'

current_dir = File.expand_path(File.dirname(__FILE__))
require "#{current_dir}/../poortego_transform.rb"

###
#
#  PoortegoTransformResponseXML Class
#
###
class PoortegoTransformResponseXML
  attr_accessor :project_id, :section_id, :transform, :xml_response, :validated
  
  #
  # Constructor
  #
  def initialize(*args)
    @validated = false
    
    if (args.length == 3)
      @project_id = args[0]
      @section_id = args[1]
      @xml_response = args[2]
      
      # Validate XML - TODO: this was just added and likely to fail from invalid XSD path, fix this
      #puts "[DEBUG] XML response being passed to validateXML: #{@xml_response}"
      validateXML(@xml_response)  ## This is causing a huge mess:
      #puts "[DEBUG] validateXML response: #{retval}"
      
      if (@validated)
        # Parse XML and process the objects
        parseXML()
      end
      
    end
  end
  
  #
  # Build XML - from transform object, build XML
  #
  def buildXML(transform_obj)
    xml_string = '<PoortegoTransformResponse xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xsi:noNamespaceSchemaLocation="' + "#{ENV['POORTEGO_LOCAL_BASE']}/lib/core/poortego_transform/xml/PoortegoTransformResponse.xsd" + '">'
    
    xml_string << '<ResponseData>'
    ## Entities
    xml_string << '<Entities>'
    transform_obj.responseEntities.each do |responseEntity|
      xml_string << '<Entity'
      responseEntity.attributes.each do |key,value|
        xml_string << " #{key}='#{value}'"
      end
      xml_string << '>'
      responseEntity.additionalFields.each do |name,value|
        xml_string << "<AdditionalField name='#{name}' value='#{value}' />"
      end
      xml_string << '</Entity>'
    end
    xml_string << '</Entities>'
    
    ## Links
    xml_string << '<Links>'
    transform_obj.responseLinks.each do |responseLink|
      xml_string << '<Link'
      responseLink.attributes.each do |key,value|
        xml_string << " #{key}='#{value}'"
      end
      xml_string << '>'
      responseLink.additionalFields.each do |name,value|
        xml_string << "<AdditionalField name='#{name}' value='#{value}' />"
      end
      xml_string << '</Link>'
    end
    xml_string << '</Links>'
    xml_string << '</ResponseData>'
    
    ## Messages
    xml_string << '<ResponseMessages>'
    transform_obj.responseMessages.each do |responseMessage|
      xml_string << "<Message "
      xml_string << "title='#{responseMessage.title}' "
      xml_string << "type='#{responseMessage.type}'>"
      xml_string << "#{responseMessage.body}"
      xml_string << '</Message>'
    end
    xml_string << '</ResponseMessages>'
    xml_string << '</PoortegoTransformResponse>'
    @xml_response = xml_string
    return @xml_response
  end
  
  #
  # Validate XML - validate XML against XSD
  #
  def validateXML(xml_string)  
    begin
      xsd_filename = "#{ENV['POORTEGO_LOCAL_BASE']}/lib/core/poortego_transform/xml/PoortegoTransformResponse.xsd"
      document = LibXML::XML::Document.string(xml_string)
      schema   = LibXML::XML::Schema.new(xsd_filename)
      result   = document.validate_schema(schema) #do |message,flag|
      #  puts "[MESSAGE] #{message}"
      #  puts "[FLAG] #{flag}"
      #end
      @validated = true
    rescue => e
      #puts "LibXML error: #{e.message}"
      #puts "Backtrace: #{e.backtrace}"
      @validated = false 
    end
    
  end
  
  #
  # Parse XML - from XML, build transform object
  #
  def parseXML()
    @transform = PoortegoTransform.new('ParsedResponse')
    result_href = XmlSimple.xml_in(@xml_response.to_s)
    
    unless (result_href.has_key?('ResponseData'))
      return
    end
    
    (result_href['ResponseData'])[0].each do |response_key, response_val|
      if (response_key == 'Entities')
        parse_entities_hash(response_val)
      elsif (response_key == 'Links')
        parse_links_hash(response_val)
      else
        puts "Invalid ResponseData key"
      end
    end
    
    (result_href['ResponseMessages'])[0].each do |message_key, message_val|
      if (message_key == 'Message')
        parse_message_hash(message_val)
      else
        puts "Invalid ResponseMessages key"
      end
    end
    
  end
  
  #
  # Parse entities parsed out in XML Simple
  #
  def parse_entities_hash(entity_hash_array)
    entity_hash_array.each do |entity_hash|
      
      ## Do an existance check first
      unless (entity_hash.has_key?("Entity"))
        next
      end
      
      entity_hash = (entity_hash["Entity"])[0]
      puts "#{entity_hash.inspect}"
      
      # Select or Insect Entity
      puts "Searching for entity #{entity_hash['title']}"
      result = Entity.select_or_insert(@project_id, @section_id, entity_hash['title'])
      result.save
      puts "Result: #{result.inspect}"
    
      # Select or Insert EntityType
      if (entity_hash.has_key?("type"))
        puts "Searching for entity type #{entity_hash['type']}"
        type_result = EntityType.select_or_insert(entity_hash['type'])
        type_result.save
        puts "Result: #{type_result.inspect}"
        
        puts "Setting entity type for entity"
        result.entity_type_id = type_result.id
        result.save 
        puts "Done." 
      end
      
      ## Other fields???
      ## Description
      if (entity_hash.has_key?("description")) 
        ## TODO: if / when needed 
      end
      ## Title
      if (entity_hash.has_key?("title"))
        ## TODO: if/when needed
      end
      
      ## Logic for attributes
      if (entity_hash.has_key?("AdditionalField"))
        (entity_hash["AdditionalField"]).each do |add_field|
           field_name = add_field['name']
           field_value = add_field['value']
           puts "[DEBUG] name: #{field_name} value: #{field_value}"
           
           ## Insert attribute field if not exists
           puts "[DEBUG] entity id: #{result.id}"
           entity_field = PoortegoEntityField.select_or_insert(result.id, field_name)
           entity_field.save
           
           ## Set attribute field
           entity_field.update_attributes('value' => field_value)
           entity_field.save
           
        end
      end
      
    end
  end
  
  #
  # Parse links parsed out of XML Simple
  #
  def parse_links_hash(link_hash_array)
    link_hash_array.each do |link_hash|
      unless (link_hash.has_key?("Link"))
        next
      end
      
      link_hash = (link_hash["Link"])[0]
      
      # Select or Insect Link
      puts "Searching for link #{link_hash['title']}"
      result = Link.select_or_insert(@project_id, @section_id, link_hash['title'])
      result.save
      puts "Result: #{result.inspect}"
      
      # Select or Insert LinkType
      if (link_hash.has_key?("type"))
        puts "Searching for link type #{link_hash['type']}"
        type_result = LinkType.select_or_insert(link_hash['type'])
        type_result.save
        puts "Result: #{type_result.inspect}"
        
        puts "Setting entity type for link"
        result.link_type_id = type_result.id
        result.save
        puts "Done." 
      end
      
      ## Other fields???
      ## Description
      if (link_hash.has_key?("description")) 
        ## TODO: if / when needed 
      end
      ## Title
      if (link_hash.has_key?("title"))
        ## TODO: if/when needed
      end
      
      ## Logic for attributes
      if (link_hash.has_key?("AdditionalField"))
        (link_hash["AdditionalField"]).each do |add_field|
           field_name = add_field['name']
           field_value = add_field['value']
           puts "[DEBUG] name: #{field_name} value: #{field_value}"
           
           ## Insert attribute field if not exists
           link_field = PoortegoLinkField.select_or_insert(result.id, field_name)
           link_field.save
           
           ## Set attribute field
           link_field.update_attributes('value' => field_value)
           link_field.save
           
        end
      end
      
    end
  end
  
  #
  # Handle messages
  #
  def parse_message_hash(message_hash_array)
    message_hash_array.each do |message_hash|
      message_text = ''
      if (message_hash.has_key?("type"))
        message_text << "[#{message_hash['type']}] "
      end
      if (message_hash.has_key?("title"))
        message_text << "#{message_hash['title']} : "
      end
      if (message_hash.has_key?("content"))
        message_text << "#{message_hash['content']}."
      end
      puts "#{message_text}"
    end
  end
  
end