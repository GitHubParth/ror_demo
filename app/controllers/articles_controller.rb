class ArticlesController < ApplicationController
  before_action :find_article, only: [:show, :edit, :update, :destroy]
  before_action :require_user, except: [:show, :index]
  before_action :require_same_user, only: [:edit, :update, :destroy]

  def show
  end

  def index
    @articles = Article.paginate(:page => params[:page], :per_page => 5)
  end

  def new
    @article = Article.new
  end

  def edit
  end

  def create
    @article = Article.new(whitelist_params)
    @article.user = current_user
    if @article.save
      flash[:notice] = "Article created successfully"
      redirect_to @article
    else 
      render 'new', status: 422
    end
  end

  def update
    if @article.update(whitelist_params)
      flash[:notice] = "Article was updated successfully"
      redirect_to @article
    else
      render 'edit', status: 422
    end
  end

  def destroy
    @article.destroy
  end

  private

  def find_article
    @article = Article.find(params[:id])
  end

  def whitelist_params
    params.require(:article).permit(:title, :description)
  end

  def require_same_user
    if current_user != @article.user && current_user.role != "admin"
      flash[:warning] = "You can only edit of delete your own articles."
      redirect_to @article
    end
  end
end