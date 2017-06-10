class AddCiLowerBoundToAlbums < ActiveRecord::Migration[5.1]
  def change
    add_column :albums, :ci_lower_bound, :float
  end
end
