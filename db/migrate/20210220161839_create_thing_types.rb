class CreateThingTypes < ActiveRecord::Migration[6.1]
  def change
    create_table :thing_types do |t|
      t.string :thing_type
      t.text :desc
    end
  end
end
