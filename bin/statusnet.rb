#!/usr/bin/ruby

$LOAD_PATH.unshift File.expand_path(File.join(File.dirname(__FILE__), "..", "lib"))
require 'rubygems'
require 'eventasaurus'
require 'net/http'
require 'trollop'

opts = Trollop::options do
  banner <<-EOS
daemon to send eventasaurus events to statusnet

Usage:
       statusnet [options]
where [options] are:
EOS

  opt :ident, "Event ident to listen for", :type => String
  opt :option, "Statusnet password for ident", :type => String
end

Trollop::die :ident, "need an ident" if !opts[:ident]
Trollop::die :option, "need a password" if !opts[:option]


def post(user, pass, status)
  api_update = "http://#{user}:#{pass}@statusnet/api/statuses/update.json"
  res = Net::HTTP.post_form(URI(api_update), 'status' => status)
  res.body
end

stomp = Eventasaurus::Consumer.new

loop do
  begin
    msg = stomp.get
    next if (msg['ident'] != opts[:ident])
    out ="#{msg['message']}"
    msg['tags'].each do |tag|
      out += "\n#" + tag
    end
    post(opts[:ident],opts[:option],out)
  end
end
