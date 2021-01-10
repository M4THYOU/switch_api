class ClusterDefault < ActiveRecord::Migration[6.1]
  def change
    change_column_default :clusters, :is_active, true
  end
end
