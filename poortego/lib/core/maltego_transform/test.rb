require 'xmlsimple'
require File.join(File.expand_path(File.dirname(__FILE__)),"maltego_response.rb")

xml_str = '<MaltegoMessage>
<MaltegoTransformResponseMessage>
<Entities>
<Entity Type="CNAME">
<Value>www.l.google.com</Value>
<Weight>100</Weight>
<AdditionalFields>
<Field MatchingRule="strict" Name="Source" DisplayName="Source of data">Active Resolve</Field>
</AdditionalFields>
</Entity>
</Entities>
<UIMessages>
</UIMessages>
</MaltegoTransformResponseMessage>
</MaltegoMessage>'

response_obj = MaltegoResponse.new(xml_str)
(response_obj.maltego_transform).resultEntities.each {|entity|
  puts "Type #{entity.entityType} Value #{entity.value}"
  puts ""
  entity.printEntity()  
}


#result_href = XmlSimple.xml_in(xml_str)
#puts "[DEBUG] inspect result: #{result_href.inspect}"
#puts "[DEBUG] result class: #{result_href.class}"

#require 'dnsruby'
#
#domainEntity = 'www.google.com'
#record_types = ['A', 'AAAA', 'NS', 'CNAME', 'SOA', 'HINFO', 'MX', 'TXT']
#
#Dnsruby::DNS.open {|dns|
#  record_types.each {|record_type|
#    dns.each_resource(domainEntity, record_type) {|rr|
#      if (rr.name.to_s == domainEntity.to_s)
#        puts "#{record_type} #{rr.rdata} #{rr.ttl}"
#      end
#    }
#  }
#}
