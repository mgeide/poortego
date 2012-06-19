
require 'rubygems'
require 'xml'
require 'libxml'
  
xml_filename = 'test.xml'  
xsd_filename = 'PoortegoTransformResponse.xsd'  

begin  
  document = LibXML::XML::Document.file(xml_filename)
rescue => e
  puts "LibXML document error: #{e.message}"
  puts "Backtrace: #{e.backtrace}"
  exit(1)  
end

begin
  schema   = LibXML::XML::Schema.new(xsd_filename)
rescue => e
  puts "LibXML schema error: #{e.message}"
  puts "Backtrace: #{e.backtrace}"
  exit(1)
end

begin
  result   = document.validate_schema(schema) do |message,flag|
    puts "[MESSAGE] #{message}"
    puts "[FLAG] #{flag}"
  end
rescue => e
  puts "LibXML schema validation: #{e.message}"
  puts "Backtrace: #{e.backtrace}" 
end