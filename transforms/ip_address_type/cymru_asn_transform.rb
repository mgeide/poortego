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
    #dns_resolver = Resolv::DNS.new()
    #resources = dns_resolver.getresources("#{entityValue}", Resolv::DNS::Resource::PTR)
    #resources.each do |resource|  
    #  ptr_domain = resource.name.to_s
    
    asn_response = `/usr/bin/whois -h whois.cymru.com " -v -f #{entityValue}"`
    asn_response.chomp!
    if (asn_response =~ /(\d+)\s+\|\s+([0-9\.]+)\s+\|\s+([0-9\.\/]+)\s+\|\s+([A-Z]+)\s+\|\s+([a-z]+)\s+\|\s+([0-9\-]+)\s+\|\s+(.*)/)
      asn            = $1
      ip             = $2
      bgp_prefix     = $3
      cc             = $4
      registry_name  = $5
      allocated_date = $6 
      asn_name       = $7
      
      entityA_attributeHash = Hash.new()
      entityA_attributeHash['title'] = entityValue
      entityA_attributeHash['type'] = 'ip_address'
      entityA_fieldHash = Hash.new()
      transform.addEntity(entityA_attributeHash, entityA_fieldHash)
      
      entityB_attributeHash = Hash.new()
      entityB_attributeHash['title'] = "#{bgp_prefix}"
      entityB_attributeHash['type'] = 'netblock'
      entityB_fieldHash = Hash.new()
      entityB_fieldHash['source'] = 'Team Cymru ASN Lookup'
      transform.addEntity(entityB_attributeHash, entityB_fieldHash)
      
      entityC_attributeHash = Hash.new()
      entityC_attributeHash['title'] = "AS#{asn}"
      entityC_attributeHash['type'] = 'asn'
      entityC_fieldHash = Hash.new()
      entityC_fieldHash['source']             = 'Team Cymru ASN Lookup'
      entityC_fieldHash['as_name']            = "#{asn_name}"
      entityC_fieldHash['as_registry']        = "#{registry_name}"
      entityC_fieldHash['as_allocation_date'] = "#{allocated_date}"
      entityC_fieldHash['as_country']         = "#{cc}"
      transform.addEntity(entityC_attributeHash, entityC_fieldHash)
      
      ## Link IP to netblock
      linkA_attributeHash = Hash.new()
      linkA_attributeHash['title'] = ''
      linkA_attributeHash['entity_a'] = entityValue
      linkA_attributeHash['entity_b'] = "#{bgp_prefix}"
      linkA_fieldHash = Hash.new()
      linkA_fieldHash['source'] = 'Team Cymru ASN Lookup'
      transform.addLink(linkA_attributeHash, linkA_fieldHash)
      
      ## Link netblock to IP
      linkB_attributeHash = Hash.new()
      linkB_attributeHash['title'] = ''
      linkB_attributeHash['entity_a'] = "#{bgp_prefix}"
      linkB_attributeHash['entity_b'] = "AS#{asn}"
      linkB_fieldHash = Hash.new()
      linkB_fieldHash['source'] = 'Team Cymru ASN Lookup'
      transform.addLink(linkB_attributeHash, linkB_fieldHash)
      
      transform_response = PoortegoTransformResponseXML.new()
      xml_response = transform_response.buildXML(transform)
      puts "#{xml_response}"   
               
    end
  end
else
  transform.addMessage("Cymru ASN Transform", "NOTE", "Entity type not set (#{transform.transformInput['entityType']}), this transform has no action to perform.")
      
  transform_response = PoortegoTransformResponseXML.new()
  xml_response = transform_response.buildXML(transform)
  puts "#{xml_response}"
 
end