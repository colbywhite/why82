require 'spec_helper'

RSpec.describe SeasonUpdates::OrphanUpdater do
  describe '#update' do
    let(:updater) { SeasonUpdates::OrphanUpdater.new @season }

    def setup_season_with_orphans(num_orphans)
      season = setup_2015_season
      home_team = create_team_in_season season, name: 'home', abbr: 'H'
      away_team = create_team_in_season season, name: 'away', abbr: 'A'
      games = create_n_offsetted_games_in_season(season, 3, home: home_team, away: away_team)

      games_info = games.collect { |g| game_to_hash g }
      # change the game time for a certain amount of orphans by one hour
      games_info[0..(num_orphans - 1)].each { |game| game[:time] += 1.hour }
      [season, games_info]
    end

    def game_to_hash(game)
      home = game.home
      away = game.away
      { time: game.time,
        home: team_to_hash(home, game.home_score),
        away: team_to_hash(away, game.away_score),
        extra_time: nil
      }
    end

    def team_to_hash(team, score = nil)
      { abbr: team.abbr,
        name: team.name,
        score: score
      }
    end

    shared_examples 'update and expect error' do
      it 'should throw ZeroOrMultipleOrphansError' do
        expect do
          updater.update single_game_info, all_games_info
        end.to raise_error(Errors::ZeroOrMultipleOrphansError)
      end
    end

    let(:single_game_info) { @games_info[-1] }
    let(:all_games_info) { @games_info }

    context 'when there are multiple orphans' do
      before :each do
        @season, @games_info = setup_season_with_orphans 2
      end

      include_examples 'update and expect error'
    end

    context 'when there are zero orphans' do
      before :each do
        @season, @games_info = setup_season_with_orphans 0
      end

      include_examples 'update and expect error'
    end

    context 'when there is 1 orphan' do
      before :each do
        @season, @games_info = setup_season_with_orphans 1
      end

      it 'should not throw ZeroOrMultipleOrphansError' do
        expect do
          updater.update single_game_info, all_games_info
        end.not_to raise_error
      end
    end
  end
end
