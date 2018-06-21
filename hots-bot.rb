# This bot has various commands that show off CommandBot.

require 'bundler/setup'
require 'rubygems'
require 'discordrb'
require 'open-uri'
require 'dotenv'
require 'nokogiri'
require 'pp'

Dotenv.load

bot_token  = ENV['bot_token']

# Here we instantiate a `CommandBot` instead of a regular `Bot`, which has the functionality to add commands using the
# `command` method. We have to set a `prefix` here, which will be the character that triggers command execution.
bot = Discordrb::Commands::CommandBot.new token: bot_token, prefix: '~'

bot.command :user do |event|
  event.user.name
end

bot.command(:hots, hots: 1) do |event, hots|
  icy_base = "https://www.icy-veins.com/heroes"

  if hots
    hots = hots.downcase
    icy_veins = "https://www.icy-veins.com/heroes/#{hots}-build-guide"

    #file = open(icy_veins)
    #document = Nokogiri::HTML(file)
    #heroes_talents = document.css('div.heroes_tldr_talents').children

    #talents = heroes_talents.gsub("\n","")
    #talents = talents.gsub("?","")
    #pp talents

    ### Resonse
    event << 'Hello ' + event.user.name + ' here is your build for '+ hots.upcase + ' have fun ;)'
    #event << talents
    event << icy_veins

    # TODO handle 404 error
    # 'Oops something went wrong maybe the given heroe : #{hots} is incorrect'
  else
    event << 'You don\'t send parameters with the command so here is the website.'
    event << icy_base
  end

end

bot.mention do |event|
  event.user.pm(
    'Yes my Lord, how can I help you ? Just type **~hots help** if you need help.'
    )
end

### WIP need to check why bot couldn't talk
bot.command(:rick) do |event|

  channel = event.user.voice_channel
  next "You're not in any voice channel!" unless channel
  bot.voice_connect(channel)
  event << "Connected to voice channel: #{channel.name}"

  pp channel
  voice_bot = event.voice
  voice_bot.play_io('https://www.youtube.com/watch?v=dQw4w9WgXcQ')
  bot.voice_destroy(channel)

end


bot.run
