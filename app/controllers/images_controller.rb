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

  def edit
    @image = Image.find_by(id: params[:id])
    redirect_to images_path if @image.nil?
  end

  def update
    @image = Image.find_by(id: params[:id])

    return redirect_to images_path if @image.nil?

    if @image.update(tag_list: params[:image][:tag_list])
      redirect_to @image
    else
      render 'edit', status: 422
    end
  end

  def create
    @image = Image.new(image_params)
    if @image.save
      redirect_to @image
    else
      render 'new', status: 422
    end
  end

  def show
    @image = Image.find(params[:id])
  end

  def destroy
    @image = Image.find(params[:id])
    @image.destroy!

    redirect_to images_path
  end

  private

  def image_params
    params.require(:image).permit(:url, :tag_list)
  end
end
