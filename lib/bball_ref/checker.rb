module BballRef
  class Checker
    include ICanHazIp
    include BballRef::Info
    include AccessRailsLogger

    def perform
      check
    end

    def check
      logger.info "Hitting BballRef from #{ip}"
      up = up?
      log_msg = "BballRef::Info.up?: #{up}"
      if up
        logger.info log_msg
      else
        logger.error log_msg
      end
      up
    end

    def self.check
      BballRef::Checker.new.check
    end
  end
end
