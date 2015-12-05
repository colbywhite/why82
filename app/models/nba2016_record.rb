class Nba2016Record < ActiveRecord::Base
  extend Record
  include Record
  belongs_to :team
end
