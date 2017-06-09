#!/usr/bin/env ruby
# encoding: utf-8

require 'bunny'

# read input from terminal
puts 'Enter Process name:'
a = gets.chomp

# instantiate new connection to RabbitMQ using Bunny
conn = Bunny.new
conn.start

# create new channel
ch   = conn.create_channel

# create the queue
q    = ch.queue('hello')

100.times do |t|
  sleep(rand(4))
  # puts entry into the queue
  ch.default_exchange.publish("#{a}) Hello world! #{t}", :routing_key => q.name)

  puts " [x] Sent 'Hello World!' #{t}"
end


conn.close