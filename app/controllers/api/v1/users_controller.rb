class Api::V1::UsersController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource
  before_action :set_user, only: [:show, :update, :destroy]

  def index
    @users = User.all
  end

  def show; end

  def create
    @user = User.new(user_params)
    @user.skip_password_validation = true
    if @user.save
      render :create, status: :created
    else
      render json: {message: @user.errors}, status: :unprocessable_entity
    end
  end

  def update
    if @user.update(user_params)
      render :update, status: :created
    else
      render json: {messaage: @user.errors}, status: :unprocessable_entity
    end
  end

  def destroy
    if @user.destroy
      render :destroy
    else
      render json: {message: @user.errors}
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :admin)
  end
end
