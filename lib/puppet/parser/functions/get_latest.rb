require 'net/http'
require 'net/https' if RUBY_VERSION < '1.9'
require 'uri'

module Puppet::Parser::Functions
  newfunction(:get_latest, type: rvalue) do |args|
    u = URI.parse(args[0])
    h = Net::HTTP.new u.host, u.port
    h.use_ssl = u.scheme == 'https'
    head = h.start do |ua|
      ua.head u.path
    end
    head['location'].sub('https://github.com/liquibase/liquibase/releases/tag/liquibase-parent-', '')
  end
end
