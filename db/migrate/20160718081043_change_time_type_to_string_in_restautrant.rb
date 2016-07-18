class ChangeTimeTypeToStringInRestautrant < ActiveRecord::Migration[5.0]
  def up
    change_column :restaurants, :open_at, :string
    change_column :restaurants, :close_at, :string
  end

  def down
    change_column :restaurants, :open_at, :time
    change_column :restaurants, :close_at, :time
  end
end
