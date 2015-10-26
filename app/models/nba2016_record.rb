class Nba2016Record < ActiveRecord::Base
  belongs_to :team

  def to_s
    "#{wins}-#{losses}-#{ties} (#{percentage})"
  end
end
