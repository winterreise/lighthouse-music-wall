class Track < ActiveRecord::Base
  has_many :reviews
  validates :title, presence: true
  validates :author, presence: true
end
