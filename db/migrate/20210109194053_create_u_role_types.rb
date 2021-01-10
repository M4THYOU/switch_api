class CreateURoleTypes < ActiveRecord::Migration[6.1]
  def change
    create_table :u_role_types do |t|
      t.string :role_type
      t.string :name
      t.text :desc

      t.timestamps
    end
  end
end
