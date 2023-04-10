class Api::V1::ArticlesController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource
  before_action :set_article, only: [:show, :update, :destroy]

  def index
    @articles = Article.all
  end

  def show; end

  def create
    @article = Article.new(article_params)
    if @article.save
      render :create, status: :created
    else
      render json: {message: @article.errors}, status: :unprocessable_entity
    end
  end

  def update
    if @article.update(article_params)
      render :update, status: :created
    else
      render json: {messaage: @article.errors}, status: :unprocessable_entity
    end
  end

  def destroy
    if @article.destroy
      render :destroy
    else
      render json: {message: @article.errors}
    end
  end

  private

  def set_article
    @article = Article.find(params[:id])
  end

  def article_params
    params.require(:article).permit(:title, :description, :content, :article_url,
                                    :published_at, :image_url, :author_id, :topic_id)
  end
end
