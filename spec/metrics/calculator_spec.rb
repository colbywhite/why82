require 'spec_helper'

RSpec.describe Metrics::Calculator do
  # This sets up the season with the following tier logic:
  # for TotalWins:
  #   the tiers should have NOP as tier 2, everyone else as tier 3
  # for TotalGames:
  #   tier 1: LAL
  #   tier 2: DET, CHI, CLE, PHI, UTA, HOU, MIN, MEM, MIL, NYK, OKC, SAS, ORL, WAS, PHO, DAL, POR, SAC, LAC, IND
  #   tier 3: TOR, CHO, MIA, DEN, BRK, BOS, NOP, GSW, ATL
  #
  # If TotalWins is weighted with 20, and TotalGames weighted with 10
  # that gives the following averaged:
  #   NOP:
  #     2.33 = (3*10+2*20)/30
  #   LAL:
  #     2.33 = (1*10+3*20)/30
  #   DET, CHI, CLE, PHI, UTA, HOU, MIN, MEM, MIL, NYK, OKC, SAS, ORL, WAS, PHO, DAL, POR, SAC, LAC, IND:
  #     2.66 = (2*10+3*20)/30
  #   TOR, CHO, MIA, DEN, BRK, BOS, GSW, ATL:
  #     3 = (3*10+3*20)/30
  #
  # Thus, overall, nobody is tier 1, LAL and NO are tier two,
  # and every other team is tier 3.
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
          tiers: Metrics::TotalWins.new(@season).named_tiers
        },
        { metric: Metrics::TotalGames, weight: 10,
          tiers: Metrics::TotalGames.new(@season).named_tiers
        }
      ]
    end
  end

  describe '#overall_tiers' do
    it 'should contain three tiers' do
      expect(@calculator.overall_tiers.count).to eq(3)
    end

    it 'should put all 30 teams in a tier' do
      all_teams = @calculator.overall_tiers.collect_concat { |t| t }
      expect(all_teams.count).to eq(30)
    end

    it 'should calculate the correct first overall tier' do
      expect(@calculator.overall_tiers.first).to be_empty
    end

    it 'should calculate the correct second overall tier' do
      # sorting makes the later assertion easier
      second_tier = @calculator.overall_tiers.second.sort_by(&:abbr)
      expect(second_tier.count).to eq(2)
      expect(second_tier.first).to eq(Team.find_by abbr: 'LAL')
      expect(second_tier.second).to eq(Team.find_by abbr: 'NOP')
    end

    it 'should calculate the correct third overall tier' do
      # sorting makes the later assertion easier
      third_tier = @calculator.overall_tiers.third.collect(&:abbr)
      expect(third_tier.count).to eq(28)
      # everbody except LAL and NOP
      expected_third_tier = Team.where.not(abbr: 'LAL').where.not(abbr: 'NOP').collect(&:abbr)

      incorrect_third_tiers = Set.new(third_tier) - Set.new(expected_third_tier)
      expect(incorrect_third_tiers).to be_empty,
                                       "#{incorrect_third_tiers.to_a} should not be in the third tier"

      missing_third_tiers = Set.new(expected_third_tier) - Set.new(third_tier)
      expect(missing_third_tiers).to be_empty,
                                     "#{missing_third_tiers.to_a} are missing from the third tier"
    end
  end

  describe '#calculate_averages' do
    it 'should calculate only valid tier averages' do
      expect(@calculator.calculate_averages.values).to only_contain_values_between(1.0, 3.0)
    end

    it 'should calculate averages for all 30 teams' do
      expect(@calculator.calculate_averages.count).to eq(30)
    end

    it 'should calculate the correct tier for each team' do
      averages = @calculator.calculate_averages
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
      averages.each do |team, avg|
        expect(avg).to eq(expected_averages[team.abbr]),
                       "#{team.abbr} has the wrong average. expected: #{expected_averages[team.abbr]}; got: #{avg}"
      end
    end
  end
end
