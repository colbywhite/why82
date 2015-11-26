task ip: :environment do
  Rails.logger.info "Current IP is: #{ICanHazIp.ip}"
end
