#!/usr/bin/ruby

$LOAD_PATH.unshift File.expand_path(File.join(File.dirname(__FILE__), "..", "lib"))
require 'rubygems'
require 'eventasaurus'

crap = Eventasaurus::Consumer.new

loop do
  begin
    msg = crap.get
    p msg

    #out = msg['ident'] + " " + msg['message']
    #msg['tags'].split(/,/).each do |tag|
    #  out += " #" + tag
    #end
    #p out
  end
end