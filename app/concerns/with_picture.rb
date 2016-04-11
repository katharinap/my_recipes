# usage:
# migration:
# rails generate migration add_picture_to_<model> picture:string
#
# <model>.rb:
# include WithPicture
# has_default_picture_size [800, 800]
# has_thumb_picture_size   [50, 50] # skip if no thumb wanted
module WithPicture
  extend ActiveSupport::Concern

  included do
    mount_uploader :picture, PictureUploader
    # class variable, separate for each class that includes this
    # module
    @image_sizes = {}
    # we need at least a default size; use this default value if not
    # defined in the class itself
    has_default_picture_size [800, 800]
  end

  # class methods
  module ClassMethods
    %i(default thumb).each do |pic_size|
      # * has_default_picture_size(size)
      # * has_thumb_picture_size(size)
      define_method "has_#{pic_size}_picture_size" do |size|
        @image_sizes[pic_size] = size
      end

      # * default_picture_size
      # * thumb_picture_size
      define_method "#{pic_size}_picture_size" do
        @image_sizes[pic_size]
      end
    end
  end

  # returns the basename of the picture file if present or nil
  def picture_file_name
    picture? ? File.basename(picture.to_s) : nil
  end
end
