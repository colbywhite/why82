class CreateNba2016Games < ActiveRecord::Migration
  def change
    create_nba2016_games
    add_foreign_key :nba2016_games, :teams, column: :away_id
    add_foreign_key :nba2016_games, :teams, column: :home_id
  end

  def create_nba2016_games
    create_table :nba2016_games do |t|
      t.datetime :time, null: false
      t.integer :away_id, index: true, null: false
      t.integer :home_id, index: true, null: false
      t.timestamps null: false
      t.timestamps null: false
      t.integer :home_score, index: true, null: true
      t.integer :away_score, index: true, null: true
    end
  end
end
