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
        COALESCE(home.home_id, away.away_id) AS team_id,
        (COALESCE(home.wins, 0) + COALESCE(away.wins, 0)) AS wins,
        (COALESCE(home.losses, 0) + COALESCE(away.losses, 0)) AS losses,
        (COALESCE(home.ties, 0) + COALESCE(away.ties, 0)) AS ties,
        ROUND((
        (COALESCE(home.wins, 0) + COALESCE(away.wins, 0) +
        ((COALESCE(home.ties, 0) + COALESCE(away.ties, 0)) * 0.5))
        /
        (COALESCE(home.wins, 0) + COALESCE(away.wins, 0) + COALESCE(home.losses, 0) + COALESCE(away.losses, 0) + COALESCE(home.ties, 0) + COALESCE(away.ties, 0))
        ), 3) AS percentage
      FROM #{games_table_prefix}_home_records AS home
      FULL OUTER JOIN #{games_table_prefix}_away_records AS away
        ON home.home_id = away.away_id
      ORDER BY percentage DESC, wins DESC;
    SQL
  end
end