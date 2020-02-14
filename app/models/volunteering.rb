class Volunteering < ActiveRecord::Base
  validates :name, presence: true
end
