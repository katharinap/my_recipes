class CreateReferences < ActiveRecord::Migration
  def change
    create_table :references do |t|
      t.integer :recipe_id
      t.string :location

      t.timestamps
    end
  end
end
