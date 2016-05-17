class User < ActiveRecord::Base

  validates :email, presence: true, uniqueness: true, confirmation: true
  validates :password, presence: true
end
