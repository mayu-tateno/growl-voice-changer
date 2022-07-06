class ChangeColumnNotNullOnTopics < ActiveRecord::Migration[6.1]
  def change
    change_column_null :topics, :body, false
  end
end
