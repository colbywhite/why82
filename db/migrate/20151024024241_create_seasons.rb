class CreateSeasons < ActiveRecord::Migration
  def up
    create_seasons_table
    season2016 = Season.where(name: '2015-16 NBA Regular').first_or_create
    add_seasons_to_teams season2016
    add_seasons_to_games season2016
  end

  def down
    remove_foreign_key :games, :season
    remove_column :games, :season_id
    remove_foreign_key :teams, :season
    remove_column :teams, :season_id
    drop_table :seasons
  end

  def create_seasons_table
    create_table :seasons do |t|
      t.string :name, index: true
      t.timestamps null: false
    end
  end

  def add_seasons_to_teams(default_season)
    add_column :teams, :season_id, :integer
    add_foreign_key :teams, :seasons
    Team.update_all season_id: default_season.id
    change_column :teams, :season_id, :integer, null: false
    add_index :teams, :season_id
  end

  def add_seasons_to_games(default_season)
    add_column :games, :season_id, :integer
    add_foreign_key :games, :seasons
    Game.update_all season_id: default_season.id
    change_column :games, :season_id, :integer, null: false, index: true
    add_index :games, :season_id
  end
end
