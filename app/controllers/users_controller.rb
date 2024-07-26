class UsersController < ApplicationController
  before_action :find_user, only: [:show, :destroy, :update, :edit]

  def index
    @users = User.all
  end

  def new
    @user = User.new
  end

  def edit
  end

  def update
    if @user.update(update_user_params)
      flash[:notice] = "Hello #{@user.username}! Your data has been updated successfully."
      redirect_to users_path
    else
      render 'edit', status: 422
    end
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:notice] = "Welcome to BlogSpot, #{@user.username}. You have successfully signed up. Please login to add your first article."
      redirect_to articles_path
    else
      render 'new', status: 422
    end
  end

  def show
  end

  def destroy
    @user.destroy
    redirect_to users_path
  end

  private

  def find_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:username, :email, :password)
  end

  def update_user_params
    params.require(:user).permit(:username, :email)
  end
end
