class AddIsSharedCol < ActiveRecord::Migration[6.1]
  def change
    add_column :clusters, :is_shared, :integer, :default => 0
  end
end
