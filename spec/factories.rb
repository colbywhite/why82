FactoryGirl.define do
  factory :league do
    name 'Default League'
    abbr 'DL'
  end

  factory :season do
    name 'Default Season'
    short_name '2016'
    league
  end

  factory :team, aliases: [:home, :away] do
    name 'Default Test Team'
    abbr 'DTT'
  end

  factory :nba2016_game do
    home
    away
    home_score nil
    away_score nil
    time { Time.zone.now }
  end

  factory :nba2015_game do
    home
    away
    home_score nil
    away_score nil
    time { Time.zone.now }
  end
end
