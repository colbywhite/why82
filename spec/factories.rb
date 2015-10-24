FactoryGirl.define do
  factory :season do
    name 'Default Season'
  end

  factory :team, aliases: [:home, :away] do
    name 'Default Test Team'
    abbr 'DTT'
    season
  end

  factory :game do
    home
    away
    time { Time.zone.now }
    season
  end
end
