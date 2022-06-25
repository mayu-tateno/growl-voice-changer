class ChangeColumnNotNullOnVoices < ActiveRecord::Migration[6.1]
  def change
    change_column_null :voices, :growl_voice, false
  end
end
