#!/usr/bin/env ruby
poortego_base = __FILE__
while File.symlink?(poortego_base)
  poortego_base = File.expand_path(File.readlink(poortego_base), File.dirname(poortego_base))
end
poortego_base_path = File.expand_path(File.dirname(poortego_base))

# Store the Poortego base dir as an environment variable
if ENV['POORTEGO_LOCAL_BASE']
  $:.unshift(ENV['POORTEGO_LOCAL_BASE']) 
else
  ENV['POORTEGO_LOCAL_BASE'] = poortego_base_path
  $:.unshift(poortego_base_path)
end

require "poortego/lib/core/poortego_transform"
require "poortego/lib/core/poortego_transform/poortego_transform_responseXML.rb"

#current_dir = File.expand_path(File.dirname(__FILE__))
#require "#{current_dir}/poortego_transform"
#require "#{current_dir}/poortego_transform_responseXML.rb"

## Testing example
#entityValue = 'google.com'
#additional_entityFields = 'type=domain#description=Test'

## TODO: I messed with this and broke my XML validation -- look into this when I have time

argumentOne = ARGV[0]   # Entity value
argumentTwo = ARGV[1]   # field1=value1#field2=value2#...

## DEBUG:
#puts "Transform arg1: #{argumentOne}"
#puts "Transform arg2: #{argumentTwo}"

transform   = PoortegoTransform.new(argumentOne, argumentTwo)
entityValue = transform.transformInput["entityValue"]

## Update with fake data as though a "dig" had occurred
## Entity Info example
entity_attributeHash = Hash.new()
entity_attributeHash['title'] = '1.1.1.1'
entity_attributeHash['type'] = 'ip_address'
entity_fieldHash = Hash.new()

## NOTE: for debugging, add an extra attribute, e.g.,
## <AdditionalField name='source' value='DigTransform' />
#entity_fieldHash['source'] = 'TestTransform'

transform.addEntity(entity_attributeHash, entity_fieldHash)


## Link Info example
link_attributeHash = Hash.new()
link_attributeHash['title'] = 'test_relation'
link_attributeHash['entity_a'] = entityValue
link_attributeHash['entity_b'] = entity_attributeHash['title']
link_fieldHash = Hash.new()
#link_fieldHash['source'] = 'testing'
transform.addLink(link_attributeHash, link_fieldHash)

## Message Example
#transform.addMessage('Example Message','info','This is a sample message')

## Output XML
transform_response = PoortegoTransformResponseXML.new()
xml_response = transform_response.buildXML(transform)
puts "#{xml_response}"

## Attempt to validate with XSD
puts "Validation attempt..."
transform_response.validateXML(xml_response)


