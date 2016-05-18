class Review < ActiveRecord::Base
  belongs_to :user
  belongs_to :track
  validates :content, presence: true, length: { minimum: 1 }
  validates_uniqueness_of :user_id, scope: [:track_id] # pairing is unique, user_id
                                                       # and track_id can only appear
                                                       # together once
end
