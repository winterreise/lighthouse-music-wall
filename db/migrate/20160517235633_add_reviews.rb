class AddReviews < ActiveRecord::Migration
  def change
    create_table :reviews do |t|
      t.integer :user_id
      t.integer :track_id
      t.string :title
      t.string :content
      t.integer :rating
      t.datetime :created_at
      t.datetime :updated_at
    end
  end
end
