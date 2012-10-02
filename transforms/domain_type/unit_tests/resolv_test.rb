
require 'resolv'

dns_resolver = Resolv::DNS.new()
resources = dns_resolver.getresources("google.com", Resolv::DNS::Resource::IN::A)
resources.each do |resource|
  puts "#{resource.address}"
end
