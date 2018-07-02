class IcyUrls
  def initialize(url = 'https://www.icy-veins.com/heroes')
    @url = url
  end

  def to_s
    url
  end

  # @param [String] _hero
  def build_url(hero)
    "#{self}/#{hero}-build-guide"
  end

  # @param [String] _hero
  def talents_url(hero)
    "#{self}/#{hero}-talents"
  end

  protected

  # @return [String]
  attr_reader :url
end
