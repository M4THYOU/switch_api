class CreateMqttMessages < ActiveRecord::Migration[6.1]
  def change
    create_table :mqtt_messages do |t|
      t.string :topic
      t.text :payload
      t.datetime :created_on

      t.index :topic
    end
  end
end
