class User < ActiveRecord::Base
  has_many :reviews
  validates :email, presence: true, uniqueness: true
  validates :password, presence: true
end
