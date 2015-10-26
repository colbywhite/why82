class AddRecordView < ActiveRecord::Migration
  def change
    reversible do |mig|
      mig.up do
        execute <<-SQL
          CREATE VIEW nba2016_away_records AS SELECT away_id,
          COUNT(CASE WHEN home_score < away_score THEN 1 END) AS wins,
          COUNT(CASE WHEN home_score > away_score THEN 1 END) AS losses,
          COUNT(CASE WHEN home_score = away_score THEN 1 END) AS ties,
          ROUND((
            COUNT(CASE WHEN home_score < away_score THEN 1 END) +
            (COUNT(CASE WHEN home_score = away_score THEN 1 END) * 0.5)
          ) / (
            COUNT(*)
          ), 3) AS percentage
          FROM nba2016_games
          WHERE nba2016_games.home_score IS NOT NULL AND nba2016_games.away_score IS NOT NULL
          GROUP BY away_id
          ORDER BY percentage DESC, wins DESC;
        SQL
        execute <<-SQL
          CREATE VIEW nba2016_home_records AS SELECT home_id,
          COUNT(CASE WHEN home_score > away_score THEN 1 END) AS wins,
          COUNT(CASE WHEN home_score < away_score THEN 1 END) AS losses,
          COUNT(CASE WHEN home_score = away_score THEN 1 END) AS ties,
          ROUND((
            COUNT(CASE WHEN home_score > away_score THEN 1 END) +
            (COUNT(CASE WHEN home_score = away_score THEN 1 END) * 0.5)
          ) / (
            COUNT(*)
          ), 3) AS percentage
          FROM nba2016_games
          WHERE nba2016_games.home_score IS NOT NULL AND nba2016_games.away_score IS NOT NULL
          GROUP BY home_id
          ORDER BY percentage DESC, wins DESC;
        SQL
        execute <<-SQL
          CREATE VIEW nba2016_records AS SELECT nba2016_home_records.home_id AS team_id,
          (nba2016_home_records.wins + nba2016_away_records.wins) AS wins,
          (nba2016_home_records.losses + nba2016_away_records.losses) AS losses,
          (nba2016_home_records.ties + nba2016_away_records.ties) AS ties,
          ROUND((
            (nba2016_home_records.wins + nba2016_away_records.wins +
            ((nba2016_home_records.ties + nba2016_away_records.ties) * 0.5))
            /
            (nba2016_home_records.wins + nba2016_away_records.wins + nba2016_home_records.losses + nba2016_away_records.losses + nba2016_home_records.ties + nba2016_away_records.ties)
          ), 3) AS percentage
          FROM nba2016_home_records
          FULL OUTER JOIN nba2016_away_records
          ON nba2016_home_records.home_id = nba2016_away_records.away_id
          ORDER BY percentage DESC, wins DESC;
        SQL
      end

      mig.down do
        execute <<-SQL
          DROP VIEW IF EXISTS nba2016_records;
          DROP VIEW IF EXISTS nba2016_home_records;
          DROP VIEW IF EXISTS nba2016_away_records;
        SQL
      end
    end
  end
end
