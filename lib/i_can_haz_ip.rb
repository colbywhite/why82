module ICanHazIp
  URL = 'https://icanhazip.com'

  def self.ip
    RestClient.get(URL) { |response| response.to_s.strip }
  end

  def ip
    ICanHazIp.ip
  end
end
