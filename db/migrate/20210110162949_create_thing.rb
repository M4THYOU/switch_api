class CreateThing < ActiveRecord::Migration[6.1]
  def change
    create_table :things do |t|
      t.string :aws_name, index: { unique: true }, :null => false
      t.string :name, :null => false
      t.string :password_digest, :null => false
      t.text :meta, :null => false
    end
  end
end
