namespace :bballref do
  task status: :environment do
    Rails.logger.info "BballRef status: #{BballRef::Info.status}"
  end

  task up: :environment do
    up = BballRef::Info.up?
    Rails.logger.info "BballRef up: #{up}"
    fail 'Can not access BballRef' unless up
  end
end

task bballref: 'bballref:up'
