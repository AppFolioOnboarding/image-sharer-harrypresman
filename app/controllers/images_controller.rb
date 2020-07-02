class ImagesController < ApplicationController
  def index
    @tags = ActsAsTaggableOn::Tag.all
    @images = if params[:tag].nil?
                Image.order(created_at: :desc).all
              else
                Image.tagged_with(params[:tag], any: true).order(created_at: :desc).all
              end
  end

  def new
    @image = Image.new
  end

  def create
    @image = Image.new(image_params)
    if @image.save
      redirect_to @image
    else
      render 'new'
    end
  end

  def show
    @image = Image.find(params[:id])
  end

  private

  def image_params
    params.require(:image).permit(:url, :tag_list)
  end
end
