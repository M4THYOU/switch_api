class UpdateFamily < ActiveRecord::Migration[6.1]
  def change
    change_column_default :families, :name, 'My Family'
    change_column_default :clusters, :name, 'My Cluster'
    add_column :families, :created_by_uid, :integer, null: false
    add_column :clusters, :created_by_uid, :integer, null: false
  end
end
