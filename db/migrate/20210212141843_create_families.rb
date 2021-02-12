class CreateFamilies < ActiveRecord::Migration[6.1]
  def change
    create_table :families do |t|
      t.string :name
      t.references :family_group, null: false, foreign_key: {to_table: :u_groups}

      t.timestamps
    end
  end
end
