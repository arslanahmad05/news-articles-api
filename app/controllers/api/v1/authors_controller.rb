class Api::V1::AuthorsController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource
  before_action :set_author, only: [:show, :update, :destroy]

  def index
    @authors = Author.all
  end

  def show; end

  def create
    @author = Author.new(author_params)
    if @author.save
      render :create, status: :created
    else
      render json: {message: @author.errors}, status: :unprocessable_entity
    end
  end

  def update
    if @author.update(author_params)
      render :update, status: :created
    else
      render json: {messaage: @author.errors}, status: :unprocessable_entity
    end
  end

  def destroy
    if @author.destroy
      render :destroy
    else
      render json: {message: @author.errors}
    end
  end

  private

  def set_author
    @author = Author.find(params[:id])
  end

  def author_params
    params.require(:author).permit(:name)
  end
end
