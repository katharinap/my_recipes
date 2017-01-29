class Ingredient < ActiveRecord::Base; end
class Reference < ActiveRecord::Base; end

class MoveIngredientsAndReferencesToRecipes < ActiveRecord::Migration
  def up
    add_column :recipes, :ingredients, :text
    add_column :recipes, :references, :text

    Recipe.all.each do |recipe|
      ingredients = Ingredient.where(recipe_id: recipe.id)
      references = Reference.where(recipe_id: recipe.id)
      recipe.update(ingredients: ingredients.map(&:value).join("\n"), references: references.map(&:location).join("\n"))
    end

    drop_table :ingredients
    drop_table :references
  end

  def down
    create_table :ingredients do |t|
      t.integer :recipe_id
      t.string :value
      
      t.timestamps
    end

    create_table :references do |t|
      t.integer :recipe_id
      t.string :location
      
      t.timestamps
    end
    
    Recipe.all.each do |recipe|
      recipe.ingredients.to_s.split("\n").map(&:strip).each do |ingredient|
        next if ingredient.blank?
        Ingredient.create(recipe_id: recipe.id, value: ingredient)
      end
      recipe.references.to_s.split("\n").map(&:strip).each do |reference|
        next if reference.blank?
        Reference.create(recipe_id: recipe.id, location: reference)
      end
    end
    remove_column :recipes, :ingredients, :text
    remove_column :recipes, :references, :text
  end
end
