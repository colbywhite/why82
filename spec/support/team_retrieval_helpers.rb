module TeamRetrievalHelpers
  def teams_with_abbr(abbrs)
    Team.where { abbr >> abbrs }
  end

  def teams_without_abbr(abbrs)
    Team.where { abbr << abbrs }
  end
end

RSpec.configure do |c|
  c.include TeamRetrievalHelpers
end
