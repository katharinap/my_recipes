# encoding: utf-8
class PictureUploader < CarrierWave::Uploader::Base
  # Include RMagick or MiniMagick support:
  # include CarrierWave::RMagick
  include CarrierWave::MiniMagick

  def cache_dir
    "#{Rails.root}/tmp/uploads"
  end

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  # # Provide a default URL as a default if there hasn't been a file uploaded:
  # def default_url
  #   "/assets/fallback/" + [version_name, "default.gif"].compact.join('_')
  # end

  process dynamic_resize_to_fit: :default

  version :thumb, if: :create_thumb? do
    process dynamic_resize_to_fit: :thumb
  end

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  def extension_white_list
    %w(jpg jpeg gif png)
  end

  def create_thumb?(_arg)
    !model.class.thumb_picture_size.nil?
  end

  def dynamic_resize_to_fit(size)
    resize_to_fit(*(model.class.send("#{size}_picture_size")))
  end
end
