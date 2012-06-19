#!/usr/bin/env ruby

current_dir = File.expand_path(File.dirname(__FILE__))
require "#{current_dir}/poortego_transform"
require "#{current_dir}/poortego_transform_responseXML.rb"

transform   = PoortegoTransform.new(ARGV)
entityValue = (transform.transformInput["entityValue"][0][0]).to_s
puts "entityValue: #{entityValue}"

case entityValue
when 'test'   ## Test 1
  puts "This is a test"
when /test[\d]/   ## Test 2
  puts "This is a test2"
when /^[A-Za-z0-9][a-zA-Z0-9\-\_\.]*\.[a-zA-Z]{2,4}$/ ## Domain Regex Match
  puts "Domain"
when /^([0-9]{1,3}\.){3}[0-9]{1,3}$/  ## IP Address Regex Match
  puts "IP Address"
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

