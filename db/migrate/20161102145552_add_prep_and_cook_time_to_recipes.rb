class AddPrepAndCookTimeToRecipes < ActiveRecord::Migration
  def change
    add_column :recipes, :prep_time, :integer
    add_column :recipes, :cook_time, :integer

    add_index :recipes, :prep_time
    add_index :recipes, :cook_time
  end
end
