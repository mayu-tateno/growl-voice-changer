class CreateVoices < ActiveRecord::Migration[6.1]
  def change
    create_table :voices, id: :uuid do |t|
      t.references :user, null: false, foreign_key: true, type: :uuid
      t.string :growl_voice
      t.string :description, null: false
      t.integer :status, null: false, default: 0

      t.timestamps
    end
  end
end
