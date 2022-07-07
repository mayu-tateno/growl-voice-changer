class CreateAnswers < ActiveRecord::Migration[6.1]
  def change
    create_table :answers, id: :uuid do |t|
      t.references :user, null: false, foreign_key: true, type: :uuid
      t.references :topic, null: false, foreign_key: true, type: :uuid
      t.string :growl_voice, null: false
      t.string :description, null: false

      t.timestamps
    end
  end
end
