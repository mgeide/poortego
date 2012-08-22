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

require "lib/core/poortego_transform"
require "lib/core/poortego_transform/poortego_transform_responseXML.rb"

argumentOne = ARGV[0]
argumentTwo = ARGV[1]

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
  when 'test'   ## Test 1
    puts "This is a test"
  when /test[\d]/   ## Test 2
    puts "This is a test2"
  when /^[A-Za-z0-9][a-zA-Z0-9\-\_\.]*\.[a-zA-Z]{2,4}$/ ## Domain Regex Match
    puts "Domain"
  when /^([0-9]{1,3}\.){3}[0-9]{1,3}$/  ## IP Address Regex Match
    entity_attributeHash = Hash.new()
    entity_attributeHash['title'] = entityValue
    entity_attributeHash['type'] = 'IP Address'
    entity_fieldHash = Hash.new()
    entity_fieldHash['test_attributeA'] = 'just using this for test purposes' ## TODO: delete after testing
    entity_fieldHash['test_attributeB'] = 'just using this for test purposes2'
    transform.addEntity(entity_attributeHash, entity_fieldHash)
    
    ## Add 2 test messages for debugging purposes ... TODO: remove after testing
    transform.addMessage("Test Message Title1", "DEBUG", "Test Message Body1")
    transform.addMessage("Test Message Title2", "DEBUG", "Test Message Body2")
    
    transform_response = PoortegoTransformResponseXML.new()
    xml_response = transform_response.buildXML(transform)
    puts "#{xml_response}"
  when /^[A-Za-z0-9][a-zA-Z0-9\-\_\.]*\@[A-Za-z0-9][a-zA-Z0-9\-\_\.]*\.[a-zA-Z]{2,4}$/  ## Email Regex Match
    puts "Email Address"
  when /^[0-9A-Fa-f]{32}$/  ## MD5 Regex Match
    puts "MD5 match"
  when /^[A-Z][a-z]{1,15} [A-Z][a-z]{1,20}$/  ## Name Regex Match
    puts "Name match"
  when /^https?\:\/\/\S+$/  ## URL Regex Match
    puts "URL match"
  when /^\/[A-Za-z0-9\-\_\.\~\?\=\&\%\#\+\/]+$/
    puts "Path"
  else
    puts "No auto type detection rules fired"
    puts "Default to type Phrase or Unknown"
  end
end
