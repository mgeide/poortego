require 'rubygems'
require 'xmlsimple'
require File.join(File.expand_path(File.dirname(__FILE__)),"maltego_transform.rb")

class MaltegoResponse
  attr_accessor :maltego_transform
  
  def initialize(*args)
    @xml_response      = args[0]
    @maltego_transform = MaltegoTransform.new('MaltegoResponse')
    parse_xml_response(@xml_response)
  end
  
  def parse_xml_response(xml_str)
    result_href = XmlSimple.xml_in(xml_str.to_s)
    
    (result_href['MaltegoTransformResponseMessage'])[0].each {|response_key, response_val|
      if (response_key == 'Entities')
        parse_entities_hash(response_val)
      elsif (response_key == 'UIMessages')
        parse_ui_hash(response_val)
      else
        puts "[DEBUG] Unknown response key/val pair:"
        puts "[DEBUG] response_key class: #{response_key.class}"
        puts "[DEBUG] response_key inspection: #{reponse_key.inspect}"
        puts "[DEBUG] response_val class: #{response_val.class}"
        puts "[DEBUG] response_val inspection: #{response_val.inspect}" 
      end 
    }
  end
  
  def parse_entities_hash(entities)
    entities[0].each {|entity_key, entity_val|
      parse_entity_hash(entity_val)
    }
  end
  
  def parse_entity_hash(entity)
    entityType    = (entity[0])['Type']
    entityValue   = ((entity[0])['Value'])[0]
    entityWeight  = ((entity[0])['Weight'])[0]
    
    added_entity  = @maltego_transform.addEntity(entityType, entityValue)
    added_entity.weight = entityWeight
    
    (entity[0])['AdditionalFields'].each {|additional_field|
        additional_field.each {|field_key, field_vals|
          field_match   = (field_vals[0])["MatchingRule"]
          field_name    = (field_vals[0])["Name"]
          field_display = (field_vals[0])["DisplayName"]
          field_content = (field_vals[0])["content"]
          added_entity.addAdditionalFields(field_name, field_display, field_match, field_content)
        }
    }
  end
  
  def parse_ui_hash(ui_href)
    ## TODO
  end
  
end