class UsersController < ApplicationController
  before_action :find_user, only: [:show, :destroy, :update, :edit, :make_admin, :remove_admin]
  before_action :require_user, except: [:index, :new, :create]
  before_action :require_same_user, only: [:edit, :update, :destroy]
  before_action :check_if_role_user, only: [:new]
  before_action :admin_only, only: [:make_admin, :remove_admin]

  def index
    @users = User.paginate(:page => params[:page], :per_page => 12)
    @users = @users.order(id: :asc)
  end

  def show
    if @user.nil?
      redirect_to users_path
    else
      @articles = @user.articles.paginate(:page => params[:page], :per_page => 5)
    end
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
      redirect_to users_path, notice: "Welcome to BlogSpot, #{@user.username}. You have successfully signed up."
    else
      render 'new', status: 422
    end
  end

  def update
    if @user.update(user_params)
      redirect_to users_path, notice: "Hello #{@user.username}! Your data has been updated successfully."
    else
      render 'edit', status: 422
    end
  end

  def destroy
    @user.destroy
    session[:user_id] = nil if @user == current_user
    redirect_to users_path, notice: "Account and all the associated articles have been deleted successfully."
  end

  def make_admin
    if @user.update(role: "admin")
      redirect_to users_path, notice: "User has been promoted to admin successfully."
    else
      redirect_to users_path, alert: "Unable to promote user to admin."
    end
  end

  def remove_admin
    if @user.update(role: "user")
      redirect_to users_path, notice: "Admin has been demoted to user successfully."
    else
      redirect_to users_path, alert: "Unable to promote admin to user."
    end
  end

  private

  def find_user
    @user = User.find_by(:id => params[:id])
  end

  def user_params
    params.require(:user).permit(:username, :email, :password, :profile_img)
  end

  def require_same_user
    if current_user != @user && !current_user.role.include?("admin")
      redirect_to @user, warning: "You can only edit or delete your profile."
    end
  end

  def check_if_role_user
    if !current_user.nil? && current_user.role == "user"
      redirect_to users_path, warning: "Your current role doesn't support this operation."
    end
  end

  def admin_only
    redirect_to users_path, alert: "You don't have the rights to access this page." unless current_user.role.include?("admin")
  end
	
end
