require 'nokogiri'
require_relative 'icy_urls'

class HotsParser
  # @return [IcyUrls]
  attr_reader :url

  def initialize(url = nil)
    @url = IcyUrls.new(*[url].compact)
  end

  # @param [String] hero
  # @return [nil|Array]
  def parse(hero = nil)
    hero = hero.to_s
    return nil if hero.empty?

    doc = Nokogiri::HTML(open(url.talents_url(hero)))
    talent_table = doc.css('table.talent_table')

    build = []
    talent_table.css('tr').each do |row|
      level = row.css('td.talent_unlock').text
      talent = []
      row.css('td.talent_list').each do |talent_container|
        ### When discordrb will suport multiple embed images replace marker by images
        talent_container.css('span.talent_container').map do |node|
          talent << [
            node.css('span.talent_marker').text.gsub(/[✔✘?]/, '✔' => '☑️', '✘' => '🚫', '?' => '❓'),
            node.css('img').attr('alt').text
          ].join(' : ')
        end
      end
      build << [
        level,
        talent
      ]
    end

    build
  end

  # @param [String] hero
  # @return [String]
  def getHeroPicture(hero)
    doc = Nokogiri::HTML(open(url.talents_url(hero)))
    'http:' + doc.css('div.page_content div.float_left img').attr('src').text
  end
end
