class CreateUGroupTypes < ActiveRecord::Migration[6.1]
  def change
    create_table :u_group_types do |t|
      t.string :group_type
      t.text :desc

      t.timestamps
    end
  end
end
