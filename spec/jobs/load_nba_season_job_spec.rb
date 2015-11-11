require 'spec_helper'

RSpec.describe LoadNbaSeasonJob do
  include ActiveJob::TestHelper
  subject(:job) { described_class.perform_later 'Reg', '2015' }

  before :each do
    allow(job).to receive(:season_url) do |season|
      "spec/resources/#{season.short_name}_one_month_partial_scores.html"
    end
    allow(job).to receive(:parse_doc) do |url|
      File.open(url) do |f|
        Nokogiri::HTML f
      end
    end
  end

  after :each do
    clear_enqueued_jobs
    clear_performed_jobs
  end

  describe '#perform_later' do
    it 'should enqueue a job' do
      job
      expect(enqueued_jobs.size).to eq 1
    end
  end

  describe '#perform' do
    it 'should load the whole season' do
      job.perform 'Test', '2015'
      seasons = Season.where short_name: '2015', name: 'Test'
      expect(seasons.count).to eq(1)
      games = seasons.first.games
      expect(games.count).to eq(26)
      teams = seasons.first.teams
      expect(teams.count).to eq(30)
    end

    it 'should update scores on second call' do
      job.perform 'Test', '2015'
      expect(num_incomplete_games('Test', '2015')).to eq(6)
      expect(num_complete_games('Test', '2015')).to eq(20)

      # use the complete month to get full scores
      allow(job).to receive(:season_url) do |season|
        "spec/resources/#{season.short_name}_one_month.html"
      end

      job.perform 'Test', '2015'
      expect(num_incomplete_games('Test', '2015')).to eq(0)
      expect(num_complete_games('Test', '2015')).to eq(26)
    end

    def get_games(name, short_name)
      Season.where(short_name: short_name, name: name).first.games
    end

    def num_incomplete_games(name, short_name)
      get_games(name, short_name).where(home_score: nil, away_score: nil).count
    end

    # rubocop doesn't understand the squeel syntax at all
    # rubocop:disable BlockEndNewline, NonNilCheck
    # rubocop:disable MultilineOperationIndentation, MultilineBlockLayout
    # rubocop:disable BlockDelimiters
    def num_complete_games(name, short_name)
      get_games(name, short_name).where{ (home_score != nil) &
          (away_score != nil) }.count
    end
    # rubocop:enable BlockEndNewline, NonNilCheck
    # rubocop:enable MultilineOperationIndentation, MultilineBlockLayout
    # rubocop:enable BlockDelimiters
  end

  describe '#create_season' do
    it 'should create a season and league' do
      job.create_season 'Test Season', '2016'
      seasons = Season.where name: 'Test Season', short_name: '2016'
      expect(seasons.count).to eq(1)
      league = seasons.first.league
      expect(league.name).to eq(LoadNbaSeasonJob::LEAGUE_NAME)
      expect(league.abbr).to eq(LoadNbaSeasonJob::LEAGUE_ABBR)
    end

    it 'should not create duplicate seasons/leagues' do
      job.create_season 'Test Season', '2016'
      job.create_season 'Test Season', '2016'
      seasons = Season.where name: 'Test Season', short_name: '2016'
      expect(seasons.count).to eq(1)
      leagues = League.where name: LoadNbaSeasonJob::LEAGUE_NAME,
                             abbr: LoadNbaSeasonJob::LEAGUE_ABBR
      expect(leagues.count).to eq(1)
    end
  end

  describe '#create_team' do
    it 'should not create duplicate teams' do
      team_info = { name: 'Test', abbr: 'T' }
      season = create(:season)
      job.create_team team_info, season
      job.create_team team_info, season
      teams = Team.where team_info
      expect(teams.count).to eq(1)
      expect(teams.first.seasons.count).to eq(1)
    end
  end

  describe '#create_game' do
    before :each do
      @game_info = { home: { score: nil,
                             name: 'Toronto Raptors',
                             abbr: 'TOR' },
                     away: { score: nil,
                             name: 'Charlotte Hornets',
                             abbr: 'CHO' },
                     time: Chronic.parse('04/15/2015 7:00PM'),
                     extra_time: '' }
      @season = create(:season)
    end

    it 'should not create duplicate games' do
      job.create_game @game_info, @season
      job.create_game @game_info, @season
      expect(@season.games.count).to eq(1)
    end

    it 'should overwrite nil scores' do
      job.create_game @game_info, @season
      games = @season.game_class.where(home_score: nil, away_score: nil)
      expect(games.count).to eq(1)
      @game_info[:home][:score] = 20
      @game_info[:away][:score] = 30
      job.create_game @game_info, @season
      games = @season.game_class.where(home_score: 20, away_score: 30)
      expect(games.count).to eq(1)
    end
  end
end
