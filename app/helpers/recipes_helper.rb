# frozen_string_literal: true
# == Schema Information
#
# Table name: recipes
#
#  id          :integer          not null, primary key
#  name        :string
#  user_id     :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  picture     :string
#  active_time :integer
#  total_time  :integer
#  prep_time   :integer
#  cook_time   :integer
#  notes       :text
#  directions  :text
#  ingredients :text
#  references  :text
#
# Indexes
#
#  index_recipes_on_active_time  (active_time)
#  index_recipes_on_cook_time    (cook_time)
#  index_recipes_on_prep_time    (prep_time)
#  index_recipes_on_total_time   (total_time)
#  index_recipes_on_user_id      (user_id)
#

module RecipesHelper
  include GlyphHelper
  include DurationHelper

  def title
    @recipe.try :name
  end

  def allow_edit?(recipe)
    return false unless user_signed_in?
    recipe.user_id == current_user.id
  end

  def edit_link(recipe)
    if allow_edit?(recipe)
      enabled_edit_link(recipe)
    else
      disabled_edit_link(recipe)
    end
  end

  def enabled_edit_link(recipe)
    tooltip = t('.edit', default: t('helpers.links.edit'))
    classes = 'action-link hidden-print'
    opt = { title: tooltip, class: classes, data: { toggle: 'tooltip' } }
    link_to edit_recipe_path(recipe), opt do
      edit_icon
    end
  end

  def disabled_edit_link(_recipe)
    link_to '#', disabled: true, class: 'action-link disabled hidden-print' do
      edit_icon
    end
  end

  def edit_icon
    content_tag :span do
      glyph 'pencil fa-lg'
    end
  end

  def destroy_link(recipe)
    if allow_edit?(recipe)
      enabled_destroy_link(recipe)
    else
      disabled_destroy_link(recipe)
    end
  end

  # rubocop:disable Metrics/LineLength
  def enabled_destroy_link(recipe)
    data = {
      confirm: t('.confirm', default: t('helpers.links.confirm', default: 'Are you sure?')),
      toggle: 'tooltip'
    }
    tooltip = t('.destroy', default: t('helpers.links.destroy'))
    opts = { method: 'delete', class: 'action-link hidden-print', data: data, id: 'delete_link', title: tooltip }
    link_to recipe_path(recipe), opts do
      destroy_icon
    end
  end

  def disabled_destroy_link(_recipe)
    opts = { data: { toggle: 'tooltip' }, title: 'Nope...', disabled: true, id: 'delete_link', class: 'action-link disabled hidden-print' }
    link_to '#', opts do
      destroy_icon
    end
  end
  # rubocop:enable Metrics/LineLength

  def destroy_icon
    content_tag :span, class: 'right-side-icon' do
      glyph 'trash fa-lg'
    end
  end

  def pdf_link(recipe)
    opts = { title: 'PDF', data: { toggle: 'tooltip' }, class: 'action-link' }
    link_to recipe_path(recipe, format: :pdf), opts do
      pdf_icon
    end
  end

  def pdf_icon
    content_tag :span, class: 'right-side-icon' do
      glyph 'file-pdf-o fa-lg'
    end
  end

  def new_link
    css_class = 'btn btn-success-outline btn-sm hidden-print'
    css_class += ' disabled' unless user_signed_in?

    link_to new_recipe_path do
      attr = { type: 'button', class: css_class }
      attr[:disabled] = true unless user_signed_in?
      content_tag :button, attr do
        'Add Recipe'
      end
    end
  end

  def recipe_image(recipe)
    return unless recipe.picture?
    content_tag :div, class: 'row' do
      if params[:format] == 'pdf'
        wicked_pdf_image_tag recipe.picture_url, class: 'center-block'
      else
        image_tag recipe.picture_url, class: 'center-block card-img-top'
      end
    end
  end

  # this is only a short term solution until we can think of a
  # better way to display this information in recipes#index
  def short_time_attribute_description(recipe)
    Recipe::TIME_ATTRIBUTES.map do |time_attr|
      next unless recipe.send time_attr
      name = time_attr.to_s.sub('_time', '').capitalize
      value = minutes_in_words(recipe.send(time_attr), short: true)
      "#{name}: #{value}"
    end.compact.join(', ')
  end
end
