class CreateCluster < ActiveRecord::Migration[6.1]
  def change
    create_table :clusters do |t|
      t.string :name
      t.boolean :is_active, :null => false, :default => false
      t.datetime :created_on, :null => false, default: -> { 'CURRENT_TIMESTAMP' }
      t.integer :created_by_uid, :null => false
    end
  end
end
