class IcyUrls
  def initialize(url = 'https://www.icy-veins.com/heroes')
    @url = url
  end

  def to_s
    url
  end

  # @param [String] hero
  # @return [String]
  def build_url(hero)
    "#{self}/#{hero}-build-guide"
  end

  # @param [String] hero
  # @return [String]-
  def talents_url(hero)
    "#{self}/#{hero}-talents"
  end

  # @return [String]
  def logo_url
    'https://static.icy-veins.com/images/common/icy-veins-icon-social.png'
  end

  protected

  # @return [String]
  attr_reader :url
end
