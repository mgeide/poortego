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

argumentOne = ARGV[0]   # Entity value
argumentTwo = ARGV[1]   # field1=value1#field2=value2#...

## DEBUG:
#puts "Transform arg1: #{argumentOne}"
#puts "Transform arg2: #{argumentTwo}"

transform   = PoortegoTransform.new(argumentOne, argumentTwo)
entityValue = transform.transformInput["entityValue"]

## DEBUG:
#transform.transformInput.each do |input_key,input_val|
#  puts "#{input_key}: #{input_val}"
#end

## Only run transform if no entityType is set...
if (transform.transformInput.include?("entityType"))
  if (transform.transformInput["entityType"] == "ip_address")
  
    # Using dig initially - we can use a Ruby gem in the future
    ptr_result = `/usr/bin/dig -x #{entityValue}`
    if (ptr_result =~ /.*\s+IN\s+PTR\s+([A-Za-z0-9\.\-\_]+)\./s)
      ptr_domain = $1
      entityA_attributeHash = Hash.new()
      entityA_attributeHash['title'] = entityValue
      entityA_attributeHash['type'] = 'ip_address'
      entityA_fieldHash = Hash.new()
      transform.addEntity(entityA_attributeHash, entityA_fieldHash)
      
      entityB_attributeHash = Hash.new()
      entityB_attributeHash['title'] = ptr_domain
      entityB_attributeHash['type'] = 'domain'
      entityB_fieldHash = Hash.new()
      entityB_fieldHash['source'] = 'Dig_PTR_Transform'
      transform.addEntity(entityB_attributeHash, entityB_fieldHash)
      
      ## Link
      link_attributeHash = Hash.new()
      link_attributeHash['title'] = 'PTR rcd'
      link_attributeHash['entity_a'] = entityValue
      link_attributeHash['entity_b'] = ptr_domain
      link_fieldHash = Hash.new()
      link_fieldHash['source'] = 'Dig_PTR_Transform'
      transform.addLink(link_attributeHash, link_fieldHash)
      
      transform_response = PoortegoTransformResponseXML.new()
      xml_response = transform_response.buildXML(transform)
      puts "#{xml_response}"   
               
    end
  
  end
else
  transform.addMessage("DigPTR Transform", "NOTE", "Entity type not set (#{transform.transformInput['entityType']}), this transform has no action to perform.")
      
  transform_response = PoortegoTransformResponseXML.new()
  xml_response = transform_response.buildXML(transform)
  puts "#{xml_response}"
 
end