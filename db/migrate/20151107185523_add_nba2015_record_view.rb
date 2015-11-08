class AddNba2015RecordView < ActiveRecord::Migration
  include SqlHelper

  def up
    prefix = 'nba2015'
    execute generate_sql_for_away_record_views(prefix)
    execute generate_sql_for_home_record_views(prefix)
    execute generate_sql_for_record_views(prefix)
  end

  def down
    execute <<-SQL.strip_heredoc.gsub(/\n/, ' ')
      DROP VIEW IF EXISTS nba2015_records;
      DROP VIEW IF EXISTS nba2015_home_records;
      DROP VIEW IF EXISTS nba2015_away_records;
    SQL
  end
end
