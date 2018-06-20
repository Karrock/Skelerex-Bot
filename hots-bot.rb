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

bot.command(:icy, icy: 1) do |event, icy|
  icy_base = "https://www.icy-veins.com/heroes"
  icy_veins = "https://www.icy-veins.com/heroes/#{icy}-build-guide"

  if icy
    file = open(icy_veins)
    document = Nokogiri::HTML(file)
    talents = document.at_css('div.heroes_tldr_talents')[0]
    pp talents

    event << 'Hello ' + event.user.name + ' here your build for '+ icy.upcase + ' have fun ;)'
    event << icy_veins
    # TODO handle 404 error
    # 'Oops something went wrong maybe the given heroe : #{icy} is incorrect'
  else
    event << 'You don\'t send parameters with the command so here is the website.'
    event << icy_base
  end

end

bot.run
