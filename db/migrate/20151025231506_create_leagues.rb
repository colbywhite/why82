class CreateLeagues < ActiveRecord::Migration
  def change
    create_table :leagues do |t|
      t.string :name, null: false
      t.string :abbr, index: true, null: false
      t.timestamps null: false
    end

    add_column :seasons, :league_id, :integer, null: false, index: true
    add_foreign_key :seasons, :leagues
  end
end
