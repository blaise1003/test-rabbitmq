#!/usr/bin/env ruby
# encoding: utf-8

require 'bunny'
require './fcm_helper'

api_key = ''

conn = Bunny.new(:automatically_recover => false, :host => 'localhost', :user => 'admin', :password => 'admin')
conn.start

ch   = conn.create_channel
q_web    = ch.queue('pq-fcm-notifications-web')

begin
  puts ' [*] Waiting for messages. To exit press CTRL+C'
  q_web.subscribe(:block => true) do |delivery_info, properties, body|
    sleep(2)
    puts " [x] FCM WEB PUSH #{body}"

    values = JSON.parse body
    fcm_helper = FcmHelper.new(api_key)

    values['recipients'].each{|id| fcm_helper.add_device(id)}

    fcm_helper.send_message_web values['title'],
                                      values['body'],
                                      values['icon'],
                                      values['click_action']

    puts '________________________________________________________'
  end
rescue Interrupt => _
  conn.close
  exit(0)
end