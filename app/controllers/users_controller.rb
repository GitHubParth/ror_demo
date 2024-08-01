class UsersController < ApplicationController
  before_action :find_user, only: [:show, :destroy, :update, :edit]
  before_action :require_user, except: [:index, :new, :create]
  before_action :require_same_user, only: [:edit, :update, :destroy]
  before_action :check_if_role_user, only: [:new]
  before_action :admin_only, only: [:make_admin, :remove_admin]

  def index
    @users = User.paginate(:page => params[:page], :per_page => 12)
    @users = @users.order(id: :asc)
  end

  def show
    @articles = @user.articles.paginate(:page => params[:page], :per_page => 5)
  end

  def new
    @user = User.new
  end

  def edit
  end

  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      flash[:notice] = "Welcome to BlogSpot, #{@user.username}. You have successfully signed up."
      redirect_to users_path
    else
      render 'new', status: 422
    end
  end

  def update
    if @user.update(user_params)
      flash[:notice] = "Hello #{@user.username}! Your data has been updated successfully."
      redirect_to users_path
    else
      render 'edit', status: 422
    end
  end

  def destroy
    @user.destroy
    session[:user_id] = nil if @user == current_user
    flash[:notice] = "Account and all the associated articles have been deleted successfully."
    redirect_to users_path
  end

  def make_admin
    @user = User.find(params[:id])
    if @user.update(role: "admin")
      redirect_to users_path, notice: "User has been promoted to admin successfully."
    else
      redirect_to users_path, alert: "Unable to promote user to admin."
    end
  end

  def remove_admin
    @user = User.find(params[:id])
    if @user.update(role: "user")
      redirect_to users_path, notice: "Admin has been demoted to user successfully."
    else
      redirect_to users_path, alert: "Unable to promote admin to user."
    end
  end

  private

  def find_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:username, :email, :password, :profile_img)
  end

  def require_same_user
    if current_user != @user && current_user.role != "admin"
      flash[:warning] = "You can only edit or delete your profile."
      redirect_to @user
    end
  end

  def check_if_role_user
    if !current_user.nil? && current_user.role == "user"
      flash[:warning] = "Your current role doesn't support this operation."
      redirect_to users_path
    end
  end

  def admin_only
    redirect_to users_path, alert: "You don't have the rights to access this page." unless current_user.role.include?("admin")
  end
	
end
