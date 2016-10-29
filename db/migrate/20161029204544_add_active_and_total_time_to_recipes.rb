class AddActiveAndTotalTimeToRecipes < ActiveRecord::Migration
  def change
    add_column :recipes, :active_time, :integer
    add_column :recipes, :total_time, :integer

    add_index :recipes, :active_time
    add_index :recipes, :total_time
  end
end
