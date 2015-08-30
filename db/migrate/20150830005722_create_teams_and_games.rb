class CreateTeamsAndGames < ActiveRecord::Migration
  def change
    create_table :teams do |t|
      t.string :name, index: true
      t.string :abbr, index: true
      t.string :logo, index: true
      t.timestamps null: false
    end

    create_table :games do |t|
      t.datetime :time
      t.references :home, team: true, index: true, foreign_key: true
      t.references :away, team: true, index: true, foreign_key: true
      t.timestamps null: false
    end
  end
end
