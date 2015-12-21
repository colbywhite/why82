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
      up ? logger.info(log_msg) : logger.error(log_msg)
      up
    rescue SocketError => e
      logger.error "Can not check BballRef #{e.message}"
      false
    end

    def self.check
      BballRef::Checker.new.check
    end
  end
end
