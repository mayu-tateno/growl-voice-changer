class ChangeDataTypeUserIdOfAuthentications < ActiveRecord::Migration[6.1]
  def up
    # authenticationsテーブルにuuidカラムを追加
    add_column :authentications, :user_uuid, :uuid, null: false
    change_table :authentications do |t|
      # authenticationsテーブルのuser_idを消して、追加したuuidカラムをuser_idにリネーム
      t.remove :user_id
      t.rename :user_uuid, :user_id
    end
  end

  def down
    add_column :authentications, :user_id_integer, :integer, null: false
    change_table :authentications do |t|
      t.remove :user_id
      t.rename :user_id_integer, :user_id
    end
  end
end
