class AddPictureToSteps < ActiveRecord::Migration[5.0]
  def change
    add_column :steps, :picture, :string
  end
end
