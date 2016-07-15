class CreateReservation < ActiveRecord::Migration[5.0]
  def change
    create_table :reservations do |t|
      t.references :table, foreign_key: true
      t.datetime :start_at
      t.datetime :end_at
    end
  end
end
