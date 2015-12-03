module AssertHelpers
  def assert_all_games_contain_matching_team(games, team_name_substring)
    games.each do |game|
      expect(num_of_matching_teams_in_game(game, team_name_substring)).to be >= 1
    end
  end

  def num_of_matching_teams_in_game(game, team_name_substring)
    game.count do |key, value|
      (key == 'home' || key == 'away') && value['name'].include?(team_name_substring)
    end
  end

  # rubocop:disable Metrics/AbcSize
  def assert_record_equals(record, wins, losses, ties, percentage)
    expect(record.wins).to eq(wins)
    expect(record.losses).to eq(losses)
    expect(record.ties).to eq(ties)
    expect(record.percentage).to eq(percentage)
    expect(record.total_games).to eq(wins + losses + ties)
  end
  # rubocop:enable Metrics/AbcSize
end

RSpec.configure do |c|
  c.include AssertHelpers
end
