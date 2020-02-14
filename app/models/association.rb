class Association < ActiveRecord::Base
  validates :name, presence: true
end
