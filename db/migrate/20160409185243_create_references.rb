class CreateReferences < ActiveRecord::Migration[5.0]
  def change
    create_table :references do |t|
      t.integer :recipe_id
      t.string :location

      t.timestamps
    end
  end
end
