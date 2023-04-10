class Api::V1::TopicsController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource
  before_action :set_topic, only: [:show, :update, :destroy]

  def index
    @topics = Topic.all
  end

  def show; end

  def create
    @topic = Topic.new(topic_params)
    if @topic.save
      render :create, status: :created
    else
      render json: {message: @topic.errors}, status: :unprocessable_entity
    end
  end

  def update
    if @topic.update(topic_params)
      render :update, status: :created
    else
      render json: {messaage: @topic.errors}, status: :unprocessable_entity
    end
  end

  def destroy
    if @topic.destroy
      render :destroy
    else
      render json: {message: @topic.errors}
    end
  end

  private

  def set_topic
    @topic = Topic.find(params[:id])
  end

  def topic_params
    params.require(:topic).permit(:name)
  end
end
