
require 'rubygems'
require 'xml'
require 'libxml'
require 'xmlsimple'
require 'core/poortego_transform.rb'

###
#
#  PoortegoTransformResponseXML Class
#
###
class PoortegoTransformResponseXML
  attr_accessor :transform, :xml_response
  
  #
  # Constructor
  #
  def initialize()
  end
  
  #
  # Build XML - from transform object, build XML
  #
  def buildXML(transform_obj)
    xml_string = '<PoortegoTransformResponse xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xsi:noNamespaceSchemaLocation="xml/PoortegoTransformResponse.xsd">'
    
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
      xsd_filename = 'xml/PoortegoTransformResponse.xsd'
      document = LibXML::XML::Document.string(xml_string)
      schema   = LibXML::XML::Schema.new(xsd_filename)
      result   = document.validate_schema(schema) do |message,flag|
        puts "[MESSAGE] #{message}"
        puts "[FLAG] #{flag}"
      end
    rescue => e
      puts "LibXML error: #{e.message}"
      puts "Backtrace: #{e.backtrace}" 
    end    
  end
  
  #
  # Parse XML - from XML, build transform object
  #
  def parseXML(xml_string)
    @transform = PoortegoTransform.new('ParsedResponse')
    result_href = XmlSimple.xml_in(xml_str.to_s)
    
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
  
  
end