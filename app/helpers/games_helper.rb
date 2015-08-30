module GamesHelper
  def game_json_options
    stndrd_excepts = [:created_at, :updated_at]
    game_excepts = stndrd_excepts + [:home_id, :away_id]
    stndrd_excepts_opts = {except: stndrd_excepts}
    game_json_options = {include: {home: stndrd_excepts_opts, away: stndrd_excepts_opts}}
    game_json_options.merge({except: game_excepts})
  end
end
