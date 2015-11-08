class Nba2015Record < ActiveRecord::Base
  extend Record
  include Record
  belongs_to :team

  def to_s
    "#{wins}-#{losses}-#{ties} (#{percentage})"
  end
end
