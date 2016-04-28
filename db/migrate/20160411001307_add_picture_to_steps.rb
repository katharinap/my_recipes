class AddPictureToSteps < ActiveRecord::Migration
  def change
    add_column :steps, :picture, :string
  end
end
