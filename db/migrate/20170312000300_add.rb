class Add < ActiveRecord::Migration
  def change
    add_index :recipes, :user_id
  end
end
