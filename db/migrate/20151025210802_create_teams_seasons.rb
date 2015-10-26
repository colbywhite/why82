class CreateTeamsSeasons < ActiveRecord::Migration
  def change
    create_teams
    create_seasons
    create_season_team_join_table

    add_foreign_key :seasons_teams, :teams
    add_foreign_key :seasons_teams, :seasons
  end

  def create_teams
    create_table :teams do |t|
      t.string :name, index: true, null: false
      t.string :abbr, index: true, null: false
      t.timestamps null: false
    end
  end

  def create_seasons
    create_table :seasons do |t|
      t.string :name, index: true, null: false
      t.string :short_name, index: true, null: false
      t.timestamps null: false
    end
  end

  def create_season_team_join_table
    create_table :seasons_teams, id: false do |t|
      t.belongs_to :team, index: true
      t.belongs_to :season, index: true
    end
  end
end
