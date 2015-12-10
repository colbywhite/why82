module GameJsonSerialization
  include JsonSerializable

  DEFAULT_JSON_OPTS = BASE_JSON_OPTS.deep_dup.merge include: { home: Team::DEFAULT_JSON_OPTS.deep_dup,
                                                               away: Team::DEFAULT_JSON_OPTS.deep_dup },
                                                    except: BASE_JSON_OPTS[:except] + [:home_id, :away_id]

  def as_json(opts = {})
    super DEFAULT_JSON_OPTS.deep_dup.merge opts
  end
end
