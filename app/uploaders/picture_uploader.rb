# encoding: utf-8
# frozen_string_literal: true
class PictureUploader < CarrierWave::Uploader::Base
  # Include RMagick or MiniMagick support:
  # include CarrierWave::RMagick
  include CarrierWave::MiniMagick

  def cache_dir
    Rails.root.join('tmp', 'uploads')
  end

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  process dynamic_resize_to_fit: :default

  version :thumb, if: :create_thumb? do
    process dynamic_resize_to_fit: :thumb
  end

  version :mid, if: :create_mid? do
    process dynamic_resize_to_fit: :mid
  end

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  def extension_white_list
    %w(jpg jpeg gif png)
  end

  def create_thumb?(_arg)
    !model.class.thumb_picture_size.nil?
  end

  def create_mid?(_arg)
    !model.class.mid_picture_size.nil?
  end

  def dynamic_resize_to_fit(size)
    resize_to_fit(*model.class.send("#{size}_picture_size"))
  end

  def default_url(*_args)
    file_name = "#{version_name}_recipe-default-img.png"
    ActionController::Base.helpers.image_path(file_name)
  end
end
