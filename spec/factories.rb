FactoryGirl.define do
  factory :team, aliases: [:home, :away] do
    name 'Default Test Team'
    abbr 'DTT'
  end

  factory :game do
    home
    away
    time { Time.zone.now }
  end
end
