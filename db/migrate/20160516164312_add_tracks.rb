class AddTracks < ActiveRecord::Migration
  def change
    create_table :tracks do |t|
      t.string :title
      t.string :author
      t.string :url
      t.datetime :created_at
      t.datetime :updated_at
    end
  end
end
