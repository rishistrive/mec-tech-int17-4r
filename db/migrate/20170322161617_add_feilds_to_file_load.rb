class AddFeildsToFileLoad < ActiveRecord::Migration[5.0]
  def change
    add_column :file_loads, :file_format, :string, default: 'food-vendors'
  end
end
