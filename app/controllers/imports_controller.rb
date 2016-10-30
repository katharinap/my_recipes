class ImportsController < ApplicationController
  def new
    input_file = File.expand_path("~/Downloads/IMG_6895.JPG") #simple PDF file
    image = RTesseract.new(input_file)
    @imported_recipe = image.to_s
    @recipe = Recipe.new
  end
end








