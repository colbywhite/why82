class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.datetime :time
      t.integer :away_id, index: true
      t.integer :home_id, index: true
      t.timestamps null: false
    end

    add_foreign_key :games, :teams, column: :home_id
    add_foreign_key :games, :teams, column: :away_id
  end
end
