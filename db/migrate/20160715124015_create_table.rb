class CreateTable < ActiveRecord::Migration[5.0]
  def change
    create_table :tables do |t|
      t.references :restaurant, foreign_key: true
      t.integer :number
    end
    add_index :tables, [:restaurant_id, :number], :name => "restaurant_table_number_index", :unique => true
  end
end
