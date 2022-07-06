class AddIndexBodyToTopics < ActiveRecord::Migration[6.1]
  def change
    add_index :topics, :body, unique: true
  end
end
