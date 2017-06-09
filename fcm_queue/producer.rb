#!/usr/bin/env ruby
# encoding: utf-8

require 'bunny'
require 'json'

# instantiate new connection to RabbitMQ using Bunny
conn = Bunny.new(:host => 'localhost', :user => 'admin', :password => 'admin')
conn.start

# create new channel
ch   = conn.create_channel

# create the queues
q_web    = ch.queue('pq-fcm-notifications-web')
q_android    = ch.queue('pq-fcm-notifications-android')

cont = 0
while true
  cont += 1
  sleep(4)

  # WEB
  notification = {
      recipients: [
        'cQAZynfM3oA:APA91bHQxYFQgGPRUHv8NDdko5rK71iAaz9jokb48g8rLwDymkh_rcUsKKt43Bjacx0XebzgbcTXDDvOYcTlOwXZrkvDnTW9sN31QAVITXmoZM8Vt1gq0n_EtlaW2JYCzAp1dYivExem',
        'dioFJfzVjbA:APA91bGqs1tbXeMPl56W68IMfVWPJloVbR-PkEMFiQsiuKUacVMAv1aURHUqq_0hgJUQoyKAYSD9TP11OanRrJ7c0kmxlXpZMot-AgfWH8aoghoX4nFAHwRyZC_2gtfacbEQsPIMnJDH',
        'c_CuKWaBaHM:APA91bHPviAhLscDUp6nEk5O12FQoxscRQJ7ktlF-P4ubj1Rw2JoKHV91v-Z11k5oVFVpE1adL6jCrBGWZ7oh1omo4IENdgIPcseCgBRGrTZu7VH5sLKTRX6F3rfWFf9uBWPWez5AGea'
      ],
      title: "Che offerte sul WEB! ===> #{cont}",
      body: 'Vieni a scoprire le offerte di questo mese',
      icon: 'https://data.promoqui.it/retailers/logos/000/000/050/thumb/mediaworld.jpg',
      click_action: 'https://www.promoqui.it/volantino/mediaworld/la-tecnologia-e-di-casa-449725'
  }

  # puts entry into the queue
  ch.default_exchange.publish(notification.to_json, :routing_key => q_web.name)

  puts " [x] Sent Web notification #{cont}"

  # ANDROID
  notification = {
      recipients: [
          'APA91bEpekfc56HRF8dgN0J3BbW8Xliz6xg7Lh2SU4zEZ8mjrh6Z2P9mGbaBtdgVAzKLCqyI_bOKArJVLA5DWop48pv6v3A_bEfECQKugEPqpEnDZtFMCxGa1bYeEXsWjjP9u-yqalm0',
          'APA91bFVh3FBUD8T5EYWD83Jfp-f-ptEcVrNqrayoSbbEWeK3cV9DuN1U1tpefFMZ76cVdttQWmkA2i6_BLSbeTJQsSwsbiKrtpVtOTrNBn7EFJYG6HM8GIxNzTO2Jy136AFlHAPaxoE'
      ],
      title: "Che offerte sul Telefono! ===> #{cont}",
      body: 'Vieni a scoprire le offerte di questo mese',
      icon: 'https://data.promoqui.it/retailers/logos/000/000/050/thumb/mediaworld.jpg',
      click_action: 'https://www.promoqui.it/volantino/mediaworld/la-tecnologia-e-di-casa-449725'
  }

  # puts entry into the queue
  ch.default_exchange.publish(notification.to_json, :routing_key => q_android.name)

  puts " [x] Sent Android notification #{cont}"
end


conn.close