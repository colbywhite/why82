module SqlHelper
  def generate_sql_for_away_record_views(games_table_prefix)
    <<-SQL.strip_heredoc.gsub(/\n/, ' ')
      CREATE VIEW #{games_table_prefix}_away_records
      AS
      SELECT
        away_id,
        COUNT(CASE
          WHEN home_score < away_score THEN 1
        END) AS wins,
        COUNT(CASE
          WHEN home_score > away_score THEN 1
        END) AS losses,
        COUNT(CASE
          WHEN home_score = away_score THEN 1
        END) AS ties,
        ROUND((COUNT(CASE
          WHEN home_score < away_score THEN 1
        END) + (COUNT(CASE
          WHEN home_score = away_score THEN 1
        END) * 0.5)) / (COUNT(*)), 3) AS percentage
      FROM #{games_table_prefix}_games
      WHERE #{games_table_prefix}_games.home_score IS NOT NULL
      AND #{games_table_prefix}_games.away_score IS NOT NULL
      GROUP BY away_id
      ORDER BY percentage DESC,
      wins DESC;
    SQL
  end

  def generate_sql_for_home_record_views(games_table_prefix)
    <<-SQL.strip_heredoc.gsub(/\n/, ' ')
      CREATE VIEW #{games_table_prefix}_home_records
      AS
      SELECT
        home_id,
        COUNT(CASE
          WHEN home_score > away_score THEN 1
        END) AS wins,
        COUNT(CASE
          WHEN home_score < away_score THEN 1
        END) AS losses,
        COUNT(CASE
          WHEN home_score = away_score THEN 1
        END) AS ties,
        ROUND((
        COUNT(CASE
          WHEN home_score > away_score THEN 1
        END) +
        (COUNT(CASE
          WHEN home_score = away_score THEN 1
        END) * 0.5)
        ) / (
        COUNT(*)
        ), 3) AS percentage
      FROM #{games_table_prefix}_games
      WHERE #{games_table_prefix}_games.home_score IS NOT NULL
      AND #{games_table_prefix}_games.away_score IS NOT NULL
      GROUP BY home_id
      ORDER BY percentage DESC, wins DESC;
    SQL
  end

  def generate_sql_for_record_views(games_table_prefix)
    <<-SQL.strip_heredoc.gsub(/\n/, ' ')
      CREATE VIEW #{games_table_prefix}_records
      AS
      SELECT
        #{games_table_prefix}_home_records.home_id AS team_id,
        (#{games_table_prefix}_home_records.wins + #{games_table_prefix}_away_records.wins) AS wins,
        (#{games_table_prefix}_home_records.losses + #{games_table_prefix}_away_records.losses) AS losses,
        (#{games_table_prefix}_home_records.ties + #{games_table_prefix}_away_records.ties) AS ties,
        ROUND((
        (#{games_table_prefix}_home_records.wins + #{games_table_prefix}_away_records.wins +
        ((#{games_table_prefix}_home_records.ties + #{games_table_prefix}_away_records.ties) * 0.5))
        /
        (#{games_table_prefix}_home_records.wins + #{games_table_prefix}_away_records.wins + #{games_table_prefix}_home_records.losses + #{games_table_prefix}_away_records.losses + #{games_table_prefix}_home_records.ties + #{games_table_prefix}_away_records.ties)
        ), 3) AS percentage
      FROM #{games_table_prefix}_home_records
      FULL OUTER JOIN #{games_table_prefix}_away_records
        ON #{games_table_prefix}_home_records.home_id = #{games_table_prefix}_away_records.away_id
      ORDER BY percentage DESC, wins DESC;
    SQL
  end
end