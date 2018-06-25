# This bot has various commands that show off CommandBot.

require 'bundler/setup'
require 'rubygems'
require 'discordrb'
require 'open-uri'
require 'dotenv'
require 'nokogiri'
require 'pp'
require 'reverse_markdown'

Dotenv.load

bot_token  = ENV['bot_token']

# Here we instantiate a `CommandBot` instead of a regular `Bot`, which has the functionality to add commands using the
# `command` method. We have to set a `prefix` here, which will be the character that triggers command execution.
bot = Discordrb::Commands::CommandBot.new token: bot_token, prefix: '~'

bot.command(:hots, hots: 1) do |event, hots|
  icy_base = "https://www.icy-veins.com/heroes"
  img_urls = Array.new
  img_captions = Array.new

  if hots
    hots = hots.downcase
    icy_guide = icy_base + "/#{hots}-build-guide"
    icy_talents = icy_base + "/#{hots}-talents"

    #doc = Nokogiri::HTML(open(icy_talents))
    #html = doc.css('table.talent_table').to_s
    #html = html.gsub("[\r\n]", "")
    #result = ReverseMarkdown.convert html

    #pp result

    ### Resonse
    event << 'Hello ' + event.user.name + ' here is your build for '+ hots.upcase + ' have fun ;)'
    event << icy_guide
    ## Hidden link preview for talents web url
    event << 'And here is the talents page : ' + '<' + icy_talents + '>'
    #event << result

    # TODO handle 404 error
    # 'Oops something went wrong maybe the given heroe : #{hots} is incorrect'
  else
    event << 'You don\'t send parameters with the command so here is the website.'
    event << icy_base
  end

end

### WIP need to check why bot couldn't talk
bot.command(:rick) do |event|

  channel = event.user.voice_channel
  next "You're not in any voice channel!" unless channel
  bot.voice_connect(channel)
  "Connected to voice channel: #{channel.name}"

  voice_bot = event.voice
  #voice_bot.play_io('https://www.youtube.com/watch?v=dQw4w9WgXcQ')
  #voice_bot.play_file('sources/audio/rickroll.mp3')
  bot.voice_destroy(channel)

end

bot.command(:kick) do |event
  |  channel = event.user.voice_channel
  if channel
    bot.voice_destroy
  end
end

bot.command(:help) do |event|
  event.user.pm(
    'Yes my Lord, here is how I can help you :
    **~hots** : with one or zero argument, you can indicate a hero to get his build from icy-veins
    **~rick** : WIP you can rickroll your friend in a voice channel'
    )
end

bot.run
