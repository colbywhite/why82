class AddScoreToGame < ActiveRecord::Migration
  def change
    add_column :games, :home_score, :int, null: true
    add_column :games, :away_score, :int, null: true
  end
end
