FactoryGirl.define do
  factory :team, aliases: [:home, :away] do
    name 'San Antonio Spurs'
    abbr 'SA'
  end

  factory :game do
    home
    away
    time '2015-08-29 13:05:01'
  end
end
