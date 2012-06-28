#!/usr/bin/env ruby

current_dir = File.expand_path(File.dirname(__FILE__))
require "#{current_dir}/poortego_transform"
require "#{current_dir}/poortego_transform_responseXML.rb"

## Testing example
entityValue = 'google.com'
additional_entityFields = 'type=domain#description=Test'

## Define a transform to populate
transform = PoortegoTransform.new(entityValue, additional_entityFields)

## Update with fake data as though a "dig" had occurred
## Entity Info example
entity_attributeHash = Hash.new()
entity_attributeHash['title'] = '1.1.1.1'
entity_attributeHash['type'] = 'IP Address'
entity_fieldHash = Hash.new()
transform.addEntity(entity_attributeHash, entity_fieldHash)
## Link Info example
link_attributeHash = Hash.new()
link_attributeHash['title'] = 'A rcd'
link_attributeHash['entity_a'] = entityValue
link_attributeHash['entity_b'] = entity_attributeHash['title']
link_fieldHash = Hash.new()
link_fieldHash['source'] = 'dig'
transform.addLink(link_attributeHash, link_fieldHash)

## Message Example
transform.addMessage('Example Message','info','This is a sample message')

## Output XML
transform_response = PoortegoTransformResponseXML.new()
xml_response = transform_response.buildXML(transform)
puts "#{xml_response}"

## Attempt to validate with XSD
puts "Validation attempt..."
transform_response.validateXML(xml_response)


