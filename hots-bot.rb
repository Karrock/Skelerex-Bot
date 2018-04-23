# This bot has various commands that show off CommandBot.

require 'bundler/setup'
require 'rubygems'
require 'discordrb'
require 'open-uri'
require 'dotenv'

Dotenv.load

bot_token  = ENV['bot_token']

# Here we instantiate a `CommandBot` instead of a regular `Bot`, which has the functionality to add commands using the
# `command` method. We have to set a `prefix` here, which will be the character that triggers command execution.
bot = Discordrb::Commands::CommandBot.new token: bot_token, prefix: '~'

bot.command :user do |event|
  event.user.name
end

bot.command(:invite, chain_usable: false) do |event|
  # This simply sends the bot's invite URL, without any specific permissions,
  # to the channel.
  event.bot.invite_url
end

bot.command(:random, min_args: 0, max_args: 2, description: 'Generates a random number between 0 and 1, 0 and max or min and max.', usage: 'random [min/max] [max]') do |_event, min, max|
  # The `if` statement returns one of multiple different things based on the condition. Its return value
  # is then returned from the block and sent to the channel
  if max
    rand(min.to_i..max.to_i)
  elsif min
    rand(0..min.to_i)
  else
    rand
  end
end

bot.command(:heroes, heroes: 1) do |_event, heroes|
  icy_base = "https://www.icy-veins.com/heroes"
  icy_veins = "https://www.icy-veins.com/heroes/#{heroes}-build-guide"

  # First Get Parameter after command
  # Look to url : https://www.icy-veins.com/heroes/{args}-build-guide
  # return all builds with titles
  # "https://www.icy-veins.com/heroes/#{args.join(' ')}-build-guide"

  if heroes
    icy_veins
  else
    icy_base
  end


end

# Keep it as example
# bot.command :long do |event|
#   event << 'This is a long message.'
#   event << 'It has multiple lines that are each sent by doing `event << line`.'
#   event << 'This is an easy way to do such long messages, or to create lines that should only be sent conditionally.'
#   event << 'Anyway, have a nice day.'
# end

bot.run
