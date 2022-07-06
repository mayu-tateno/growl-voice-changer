class CreateTopics < ActiveRecord::Migration[6.1]
  def change
    create_table :topics, id: :uuid do |t|
      t.references :user, null: false, foreign_key: true, type: :uuid
      t.string :body

      t.timestamps
    end
  end
end
