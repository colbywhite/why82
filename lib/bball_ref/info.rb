module BballRef
  module Info
    ROOT = 'http://www.basketball-reference.com'

    # rubocop:disable SymbolProc
    def self.status
      RestClient.get(ROOT) { |response| response.code }
    end
    # rubocop:enable SymbolProc

    def self.up?
      status == 200
    end

    def status
      BballRef::Info.status
    end

    def up?
      BballRef::Info.up?
    end
  end
end
