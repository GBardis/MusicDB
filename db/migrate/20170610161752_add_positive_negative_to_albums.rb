class AddPositiveNegativeToAlbums < ActiveRecord::Migration[5.1]
  def change
    add_column :albums, :positive, :integer
    add_column :albums, :negative, :integer
  end
end
