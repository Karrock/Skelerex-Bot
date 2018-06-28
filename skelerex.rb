# This bot has various commands that show off CommandBot.

require 'bundler/setup'
require 'rubygems'
require 'discordrb'
require 'open-uri'
require 'dotenv'
require 'nokogiri'
require 'rubocop'
require 'pp'

Dotenv.load

bot_token = ENV['bot_token']

# Here we instantiate a `CommandBot` instead of a regular `Bot`, which has the functionality to add commands using the
# `command` method. We have to set a `prefix` here, which will be the character that triggers command execution.
bot = Discordrb::Commands::CommandBot.new token: bot_token, prefix: '~'

bot.command(:hots, hots: 1) do |event, hots|
  icy_base = 'https://www.icy-veins.com/heroes'

  if hots
    hots = hots.downcase
    icy_guide = icy_base + "/#{hots}-build-guide"
    icy_talents = icy_base + "/#{hots}-talents"

    doc = Nokogiri::HTML(open(icy_talents))
    hero_picture = 'http:' + doc.css('div.page_content div.float_left img').attr('src').text
    talent_table = doc.css('table.talent_table')

    # get table rows
    rows = []
    talent_table.css('tr').each do |row|
      level = row.css('td.talent_unlock').text
      talent = []
      row.css('span.talent_container').each do |talent_container|
        ### When discordrb will suport multiple embed images replace marker by images
        talent << talent_container.css('img').map { |node| node.attr('alt') + ' : ' + talent_container.css('span.talent_marker').text }
      end
      rows << [
        level,
        talent
      ]
    end

    # puts rows

    ### Resonse
    event.channel.send_embed do |embed|
      embed.author = Discordrb::Webhooks::EmbedAuthor.new(name: 'KooPa')
      embed.title = 'Hi ' + event.user.name + ' here is your build for ' + hots.upcase + ' have fun :'
      embed.description = icy_guide
      embed.colour = 0x97d352
      embed.image = Discordrb::Webhooks::EmbedImage.new(url: hero_picture)
      embed.timestamp = Time.new
      embed.thumbnail = Discordrb::Webhooks::EmbedThumbnail.new(url: 'https://static.icy-veins.com/images/common/icy-veins-icon-social.png')
      embed.footer = Discordrb::Webhooks::EmbedFooter.new(text: 'Prowdly powered in ruby')

      embed.add_field(
        name: 'And here is the talents page :',
        value: icy_talents,
        inline: false
      )
      # rows.each do |row|
      #   embed.add_field(
      #     name: ' ',
      #     value: row,
      #     inline: true
      #   )
      # end
    end

  else
    event.channel.send_embed do |embed|
      embed.author = Discordrb::Webhooks::EmbedAuthor.new(name: 'KooPa')
      embed.title = 'Hi ' + event.user.name
      embed.description = '**Tip : You can add parameters to this command such as the hero name you want.**'
      embed.colour = 0x97d352
      embed.timestamp = Time.new
      embed.thumbnail = Discordrb::Webhooks::EmbedThumbnail.new(url: 'https://static.icy-veins.com/images/common/icy-veins-icon-social.png')
      embed.footer = Discordrb::Webhooks::EmbedFooter.new(text: 'Prowdly powered in ruby')
      embed.add_field(
        name: 'Here is base url of the website.',
        value: icy_base,
        inline: false
      )
    end
  end
end

### WIP need to check why bot couldn't talk
bot.command(:rick) do |event|
  channel = event.user.voice_channel
  next "You're not in any voice channel!" unless channel
  bot.voice_connect(channel)
  event << "Connected to voice channel: #{channel.name}"

  voice_bot = event.voice
  # voice_bot.play_io('https://www.youtube.com/watch?v=dQw4w9WgXcQ')
  voice_bot.play_file('sources/audio/music.mp3')
  bot.voice_destroy(channel)
end

bot.command(:kick) do |event|
  channel = event.user.voice_channel
  bot.voice_destroy(channel) if channel
end

bot.command(:help) do |event|
  event.user.pm(
    'Yes my Lord, here is how I can help you :
    **~hots** : with one or zero argument, you can indicate a hero to get his build from icy-veins
    **~rick** : WIP you can rickroll your friend in a voice channel'
  )
end

bot.run
