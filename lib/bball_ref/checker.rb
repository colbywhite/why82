module BballRef
  class Checker
    include ICanHazIp
    include BballRef::Info

    def perform
      check
    end

    def check
      Rails.logger.info "Hitting BballRef from #{ip}"
      up = up?
      log_msg = "BballRef::Info.up?: #{up}"
      if up
        Rails.logger.info log_msg
      else
        Rails.logger.error log_msg
      end
      up
    end

    def self.check
      BballRef::Checker.new.check
    end
  end
end
