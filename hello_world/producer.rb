#!/usr/bin/env ruby
# encoding: utf-8

require 'bunny'

# read input from terminal
puts 'Enter Process name:'
a = gets.chomp

# instantiate new connection to RabbitMQ using Bunny
conn = Bunny.new(:host => 'localhost', :user => 'admin', :password => 'admin')
conn.start

# create new channel
ch   = conn.create_channel

# create the queue
q    = ch.queue('hello')

cont = 0
while true
  cont += 1
  sleep(rand(4))
  # puts entry into the queue
  ch.default_exchange.publish("#{a}) Hello world! #{cont}", :routing_key => q.name)

  puts " [x] Sent 'Hello World!' #{cont}"
end


conn.close