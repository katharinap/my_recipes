class Step < ActiveRecord::Base; end

class AddDirectionsToRecipes < ActiveRecord::Migration
  def up
    add_column :recipes, :directions, :text

    Recipe.all.each do |recipe|
      steps = Step.where(recipe_id: recipe.id)
      recipe.update(directions: steps.map(&:description).join("\n\n"))
    end

    drop_table :steps
  end

  def down
    create_table :steps do |t|
      t.integer :recipe_id
      t.integer :idx
      t.text :description

      t.timestamps
    end
    
    Recipe.all.each do |recipe|
      recipe.directions.to_s.split("\n").map(&:strip).each_with_index do |description, idx|
        next if description.blank?
        Step.create(recipe_id: recipe.id, description: description, idx: idx + 1)
      end
    end
    remove_column :recipes, :directions, :text
  end
end
