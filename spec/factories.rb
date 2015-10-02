FactoryGirl.define do
  factory :team, aliases: [:home, :away] do
    name 'San Antonio Spurs'
    abbr 'SA'
  end

  factory :game do
    home
    away
    time { Time.zone.now }
  end
end
