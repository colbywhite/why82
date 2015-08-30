class CreateTeams < ActiveRecord::Migration
  def change
    create_table :teams do |t|
      t.string :name, index: true
      t.string :abbr, index: true
      t.string :logo, index: true
      t.timestamps null: false
    end
  end
end
