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
  
  transform.addMessage("AutoType Transform", "NOTE", "Entity type already set (#{transform.transformInput['entityType']}), this transform has no action to perform.")
      
  transform_response = PoortegoTransformResponseXML.new()
  xml_response = transform_response.buildXML(transform)
  puts "#{xml_response}"
  return
  
else
  case entityValue
  #when 'test'   ## Test 1
  #  puts "This is a test"
  #when /test[\d]/   ## Test 2
  #  puts "This is a test2"
  when /^[A-Za-z0-9][a-zA-Z0-9\-\_\.]*\.[a-zA-Z]{2,4}$/ ## Domain Regex Match
    puts "domain"
  when /^([0-9]{1,3}\.){3}[0-9]{1,3}$/  ## IP Address Regex Match
    entity_attributeHash = Hash.new()
    entity_attributeHash['title'] = entityValue
    entity_attributeHash['type'] = 'ip_address'
    entity_fieldHash = Hash.new()
    #entity_fieldHash['test_attributeA'] = 'just using this for test purposes' ## TODO: delete after testing
    #entity_fieldHash['test_attributeB'] = 'just using this for test purposes2'
    transform.addEntity(entity_attributeHash, entity_fieldHash)
    
    ## Add 2 test messages for debugging purposes ... TODO: remove after testing
    #transform.addMessage("Test Message Title1", "DEBUG", "Test Message Body1")
    #transform.addMessage("Test Message Title2", "DEBUG", "Test Message Body2")
    
    transform_response = PoortegoTransformResponseXML.new()
    xml_response = transform_response.buildXML(transform)
    puts "#{xml_response}"
  when /^[A-Za-z0-9][a-zA-Z0-9\-\_\.]*\@[A-Za-z0-9][a-zA-Z0-9\-\_\.]*\.[a-zA-Z]{2,4}$/  ## Email Regex Match
    puts "email_address"
  when /^[0-9A-Fa-f]{32}$/  ## MD5 Regex Match
    puts "md5"
  when /^[A-Z][a-z]{1,15} [A-Z][a-z]{1,20}$/  ## Name Regex Match
    puts "name"
  when /^https?\:\/\/\S+$/  ## URL Regex Match
    puts "url"
  when /^\/[A-Za-z0-9\-\_\.\~\?\=\&\%\#\+\/]+$/
    puts "path"
  else
    puts "No auto type detection rules fired"
    puts "Default to type Phrase or Unknown"
  end
end
