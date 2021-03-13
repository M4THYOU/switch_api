class DefaultMqttMessageDate < ActiveRecord::Migration[6.1]
  def change
    change_column_default :mqtt_messages, :created_on, -> { 'CURRENT_TIMESTAMP' }
  end
end
