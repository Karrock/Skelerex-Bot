# This bot has various commands that show off CommandBot.

require 'bundler/setup'
require 'rubygems'
require 'discordrb'
require 'open-uri'
require 'dotenv'
require 'nokogiri'
require 'pp'
require 'mechanize'
require 'httparty'

# instantiate the token in .env file
Dotenv.load
bot_token = ENV['bot_token']

require_relative 'lib/hots_parser'
require_relative 'lib/icy_urls'

# Here we instantiate a `CommandBot` instead of a regular `Bot`, which has the functionality to add commands using the
bot = Discordrb::Commands::CommandBot.new token: bot_token, prefix: '?', help_command: true

bot.command(:hots, hots: 1) do |event, hots|
  if !hots
    event.channel.send_embed do |embed|
      embed.author = Discordrb::Webhooks::EmbedAuthor.new(name: 'KooPa')
      embed.title = 'Hi ' + event.user.name
      embed.description = '**Tip : You can add parameters to this command such as the hero name you want.**'
      embed.colour = 0x97d352
      embed.timestamp = Time.new
      embed.thumbnail = Discordrb::Webhooks::EmbedThumbnail.new(url: IcyUrls.new.logo_url)
      embed.footer = Discordrb::Webhooks::EmbedFooter.new(text: 'Prowdly powered in ruby')
      embed.add_field(
        name: 'Here is base url of the website.',
        value: IcyUrls.new.to_s,
        inline: false
      )
    end
  else
    hots = hots.downcase

    build = HotsParser.new.parse(hots)

    # build the response
    event.channel.send_embed do |embed|
      embed.author = Discordrb::Webhooks::EmbedAuthor.new(name: 'KooPa')
      embed.title = "Hi #{event.user.name} here is your build for #{hots.upcase} have fun :"
      embed.description = IcyUrls.new.build_url(hots)
      embed.colour = 0x97d352
      embed.image = Discordrb::Webhooks::EmbedImage.new(url: HotsParser.new.getHeroPicture(hots))
      embed.timestamp = Time.new
      embed.thumbnail = Discordrb::Webhooks::EmbedThumbnail.new(url: IcyUrls.new.logo_url)
      embed.footer = Discordrb::Webhooks::EmbedFooter.new(text: 'Prowdly powered in ruby')

      embed.add_field(
        name: 'And here is the talents page :',
        value: IcyUrls.new.talents_url(hots),
        inline: false
      )
      build.each do |talent_array|
        embed.add_field(
          name: "__**Level #{talent_array[0]} :**__",
          value: talent_array[1].join("\n"),
          inline: true
        )
      end
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
  voice_bot.play_io('https://www.youtube.com/watch?v=dQw4w9WgXcQ')
  # voice_bot.play_file('sources/audio/music.mp3')
  bot.voice_destroy(channel)
end


bot.command(:dick) do |event|
  agent = Mechanize.new
  link = 'https://source.unsplash.com/random/featured/?Dick,Penis'
  agent.get(link).save "sources/unsplash/pic_dick.png"
  event.send_file(File.open('sources/unsplash/pic_dick.png', 'r'), caption: "Hey mais range moi ça " + event.user.name + "!" )
  sleep(5)
  event File.delete("sources/unsplash/pic_dick.png")
end

bot.command(:loutres) do |event|
  agent = Mechanize.new
  link = 'https://source.unsplash.com/random/featured/?Otter'
  agent.get(link).save "sources/unsplash/pic_otter.png"
  event.send_file(File.open('sources/unsplash/pic_otter.png', 'r'), caption: "LOUTRES QUEL EST VOTRE METIER ?!" )
  sleep(5)
  event File.delete("sources/unsplash/pic_otter.png")
end

bot.command(:zombie) do |event|
  agent = Mechanize.new
  link = 'https://source.unsplash.com/random/featured/?Zombie'
  agent.get(link).save "sources/unsplash/pic_otter.png"
  event.send_file(File.open('sources/unsplash/pic_otter.png', 'r'), caption: "AH PLANQUES TON CERVEAU " + event.user.name + "!"  )
  sleep(5)
  event File.delete("sources/unsplash/pic_otter.png")
end

bot.command(:food) do |event|
  agent = Mechanize.new
  link = 'https://source.unsplash.com/random/featured/?Food,Meal'
  agent.get(link).save "sources/unsplash/pic_food.png"
  event.send_file(File.open('sources/unsplash/pic_food.png', 'r'), caption: "Voiçi votre repas " + event.user.name + ".")
  sleep(5)
  event File.delete("sources/unsplash/pic_food.png")
end

bot.command(:pic, pic: 1 ) do |event|
  agent = Mechanize.new
  link = 'https://source.unsplash.com/random/featured/?' + pic
  agent.get(link).save "sources/unsplash/pic_" + pic + ".png"
  event.send_file(File.open('sources/unsplash/pic_' + pic +'.png', 'r'), caption: "Voiçi votre repas " + event.user.name + ".")
  sleep(5)
  event File.delete("sources/unsplash/pic_" + pic + ".png")
end

bot.command(:mc) do |event|
  agent = Mechanize.new
  url = 'https://panel.omgserv.com/json/304624/status'
  response = HTTParty.get(url)
  event.respond response.parsed_response
end

bot.command(:kick) do |event|
  channel = event.user.voice_channel
  bot.voice_destroy(channel) if channel
end

bot.run
