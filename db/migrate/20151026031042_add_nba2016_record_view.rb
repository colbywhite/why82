class AddNba2016RecordView < ActiveRecord::Migration
  include SqlHelper

  def up
    prefix = 'nba2016'
    execute generate_sql_for_away_record_views(prefix)
    execute generate_sql_for_home_record_views(prefix)
    execute generate_sql_for_record_views(prefix)
  end

  def down
    execute <<-SQL.strip_heredoc.gsub(/\n/, ' ')
      DROP VIEW IF EXISTS nba2016_records;
      DROP VIEW IF EXISTS nba2016_home_records;
      DROP VIEW IF EXISTS nba2016_away_records;
    SQL
  end
end
