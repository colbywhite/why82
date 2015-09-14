class RemoveLogoFromTeam < ActiveRecord::Migration
  def change
    remove_column :teams, :logo, :string
  end
end
