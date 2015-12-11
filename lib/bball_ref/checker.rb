module BballRef
  class Checker
    include ICanHazIp
    include BballRef::Info

    def perform
      Rails.logger.info "Hitting BballRef from #{ip}"
      up = up?
      Rails.logger.info "BballRef::Info.up?: #{up}"
      up
    end
  end
end
