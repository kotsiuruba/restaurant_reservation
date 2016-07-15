class CreateRestaurant < ActiveRecord::Migration[5.0]
  def change
    create_table :restaurants do |t|
      t.string :title
      t.time :open_at
      t.time :close_at
    end
  end
end
