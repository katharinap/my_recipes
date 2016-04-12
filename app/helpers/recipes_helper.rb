module RecipesHelper
  def title
    @recipe.try :name
  end
  
  def allow_edit?(recipe)
    return false unless user_signed_in?
    recipe.user_id == current_user.id
  end

  def edit_link(recipe)
    if allow_edit?(recipe)
      tooltip = t('.edit', default: t("helpers.links.edit"))
      link_to edit_recipe_path(recipe), title: tooltip, data: { toggle: 'tooltip' } do
        glyph 'pencil fa-lg'
      end
    else
      link_to '#', disabled: true do
        glyph 'pencil fa-lg'
      end
    end
  end

  def destroy_link(recipe)
    if allow_edit?(recipe)
      data = {
        confirm: t('.confirm', default: t("helpers.links.confirm", default: 'Are you sure?')),
        toggle: 'tooltip'
      }
      tooltip = t('.destroy', default: t("helpers.links.destroy"))
      link_to recipe_path(recipe), method: 'delete', data: data, title: tooltip do
        glyph 'trash fa-lg'
      end
    else
      link_to '#', data: { toggle: 'tooltip' }, title: 'Nope...', disabled: true do
        glyph 'trash fa-lg'
      end
    end
  end

  def new_link
    link_to new_recipe_path do
      content_tag :button, type: 'button', class: 'btn btn-success-outline btn-sm' do
        'Add Recipe'
      end
    end
  end
end
