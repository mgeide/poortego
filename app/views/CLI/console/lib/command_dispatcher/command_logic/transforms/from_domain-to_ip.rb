#!/usr/bin/env ruby

# Using Maltego Ruby libraries from here:
# http://www.paterva.com/forum/index.php/topic,210.0.html
#
#require "maltego_transform.rb"
#me = MaltegoTransform();
#me.debug("Starting Transform"); #Debug Info
#me.addEntity("Person","Robert McArdle"); #New Person Entity
#me.printOutput();
#
#
#More Advanced Example:
#require "maltego_transform.rb"
#me = MaltegoTransform();
#me.debug("Starting Transform"); #Debug Info
#NewEnt = me.addEntity("Person","Robert McArdle"); #New Person Entity
#NewEnt.weight = 300; #Set the Weight of the entity
#NewEnt.addAdditionalFields("Age","Age Of Person","strict","28");
#me.printOutput();

#require File.join(File.expand_path(File.dirname(__FILE__)),"maltego_transform.rb")
require 'dnsruby'
current_dir = File.expand_path(File.dirname(__FILE__))
require "#{current_dir}/maltego_transform"

transform = MaltegoTransform.new(ARGV)
#transform.debug("Starting Transform")

domainEntity = transform.entityFields['entityValue']  # May need to debug, this is returning a 2D Array
                                                      # Should be a string
#puts "[DEBUG] looking up #{domainEntity}, class: #{domainEntity.class}"
entity = domainEntity[0][0]
#puts "[DEBUG] looking up #{entity}, class: #{entity.class}"

record_types = ['A', 'AAAA', 'NS', 'CNAME', 'SOA', 'HINFO', 'MX', 'TXT']




Dnsruby::DNS.open {|dns|
  record_types.each {|record_type|
    begin
    dns.each_resource(entity.to_s, record_type.to_s) {|rr|
      if (rr.name.to_s == entity.to_s)
        #puts "#{record_type} #{rr.rdata} #{rr.ttl}"
        NewEnt = transform.addEntity(record_type.to_s, rr.rdata.to_s)
        NewEnt.addAdditionalFields("Source","Source of data","strict","Active Resolve")
      end
    }
    rescue => e
      puts e.message
      puts e.backtrace
    end  
  }
}

transform.printOutput()
#puts "done"
