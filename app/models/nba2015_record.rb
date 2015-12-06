class Nba2015Record < ActiveRecord::Base
  extend Record
  include Record
  belongs_to :team
end
