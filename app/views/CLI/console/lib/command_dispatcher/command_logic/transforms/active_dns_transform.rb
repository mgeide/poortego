#!/usr/bin/env ruby

require 'dnsruby'

#### Do these TODOs later after I have something working
## TODO: create poortego transform class for other transforms to inherit
## TODO: create poortego transform output class for transforms to use for building response

# For example:
#<PoortegoTransformResponseMessage>
#<Project title='xyz'>
#  <Section title='pdq'>
#    <Entity title='google.com' type='domain' />
#    <Entity title='www.l.google.com' type='domain' />
#    <Link title='CNAME' entity_a='google.com' entity_b='www.l.google.com' />
#  </Section>
#</Project>
#</PoortegoTransformResponseMessage>

entity = ARGV[0]

record_types = ['A', 'AAAA', 'NS', 'CNAME', 'SOA', 'HINFO', 'MX', 'TXT']

Dnsruby::DNS.open {|dns|
  record_types.each {|record_type|
    begin
    dns.each_resource(entity.to_s, record_type.to_s) {|rr|
      puts "#{rr.inspect}"
      #if (rr.name.to_s == entity.to_s)
        #puts "#{record_type} #{rr.rdata} #{rr.ttl}"
        #NewEnt = transform.addEntity(record_type.to_s, rr.rdata.to_s)
        #NewEnt.addAdditionalFields("Source","Source of data","strict","Active Resolve")
      #end
    }
    rescue => e
      puts e.message
      puts e.backtrace
    end  
  }
}