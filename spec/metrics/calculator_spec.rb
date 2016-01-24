require 'spec_helper'

RSpec.describe Metrics::Calculator do
  describe '#calculate_tiers' do
    before :each do
      # create season and play only one game
      @season = setup_2015_season
      setup_oct_28_2015_games @season
      @first_game = @season.games.order(:time).first
      @first_game.update home_score: 110, away_score: 90
      @first_game.reload

      @calculator = Metrics::Calculator.new @season
      allow(@calculator).to receive(:metric_configs) do
        [
          { metric: Metrics::TotalWins, weight: 20,
            tiers: Metrics::TotalWins.named_tiers(@season)
          },
          { metric: Metrics::TotalGames, weight: 10,
            tiers: Metrics::TotalGames.named_tiers(@season)
          }
        ]
      end
    end

    # for TotalWins:
    #   the tiers should have NOP as tier 2, everyone else as tier 3
    # for TotalGames:
    #   tier 1: LAL
    #   tier 2: DET, CHI, CLE, PHI, UTA, HOU, MIN, MEM, MIL, NYK, OKC, SAS, ORL, WAS, PHO, DAL, POR, SAC, LAC, IND
    #   tier 3: TOR, CHO, MIA, DEN, BRK, BOS, NOP, GSW, ATL
    # for both with the above weights, that gives:
    #   NOP:
    #     2.33 = (3*10+2*20)/30
    #   LAL:
    #     2.33 = (1*10+3*20)/30
    #   DET, CHI, CLE, PHI, UTA, HOU, MIN, MEM, MIL, NYK, OKC, SAS, ORL, WAS, PHO, DAL, POR, SAC, LAC, IND:
    #     2.66 = (2*10+3*20)/30
    #   TOR, CHO, MIA, DEN, BRK, BOS, GSW, ATL:
    #     3 = (3*10+3*20)/30
    it 'should calculate the correct tier for each team' do
      team_tiers = @calculator.calculate_tiers
      expected_averages = {}
      %w(LAL NOP).each do |abbr|
        expected_averages[abbr] = 7.0 / 3
      end
      %w(DET CHI CLE PHI UTA HOU MIN MEM MIL NYK OKC SAS ORL WAS PHO DAL POR SAC LAC IND).each do |abbr|
        expected_averages[abbr] = 8.0 / 3
      end
      %w(TOR CHO MIA DEN BRK BOS GSW ATL).each do |abbr|
        expected_averages[abbr] = 3.0
      end
      team_tiers.each do |team, avg|
        expect(avg).to eq(expected_averages[team.abbr]),
                       "#{team.abbr} has the wrong average. expected: #{expected_averages[team.abbr]}; got: #{avg}"
      end
    end

    it 'should calculate tiers for all 30 teams' do
      expect(@calculator.calculate_tiers.count).to eq(30)
    end

    it 'should sort result by values' do
      expect(@calculator.calculate_tiers.values).to be_monotonically_increasing
    end

    it 'should calculate only valid tier averages' do
      expect(@calculator.calculate_tiers.values).to only_contain_values_between(1.0, 3.0)
    end
  end
end
