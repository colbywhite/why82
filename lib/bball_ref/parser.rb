module BballRef
  module Parser
    def parse_doc(url)
      html = RestClient.get(url).to_str
      Nokogiri::HTML html
    end

    ##
    # Parses text out of a node while striping out redundant whitespace.
    def parse_clean_text(node, xpath_str)
      node.xpath(xpath_str).text.strip.gsub(/\s+/, ' ')
    end
  end
end
