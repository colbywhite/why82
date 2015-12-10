module GameJsonSerialization
  include JsonSerializable

  DEFAULT_JSON_OPTS = BASE_JSON_OPTS.merge include: { home: Team::DEFAULT_JSON_OPTS,
                                                      away: Team::DEFAULT_JSON_OPTS },
                                           except: BASE_JSON_OPTS[:except] + [:home_id, :away_id]

  def as_json(opts = {})
    super DEFAULT_JSON_OPTS.merge(opts)
  end
end
