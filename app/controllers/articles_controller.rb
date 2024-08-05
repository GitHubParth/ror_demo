class ArticlesController < ApplicationController
  before_action :find_article, only: [:show, :edit, :update, :destroy]
  before_action :require_user, except: [:show, :index]
  before_action :require_same_user, only: [:edit, :update, :destroy]

  def show
    if @article.nil?
      redirect_to articles_path
    end
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
      redirect_to @article, notice: "Article created successfully"
    else 
      render 'new', status: 422
    end
  end

  def update
    if @article.update(whitelist_params)
      redirect_to @article, notice: "Article was updated successfully"
    else
      render 'edit', status: 422
    end
  end

  def destroy
    @article.destroy
    redirect_to articles_path
  end

  private

  def find_article
    @article = Article.find_by(:id => params[:id])
  end

  def whitelist_params
    params.require(:article).permit(:title, :description, :category_ids => [])
  end

  def require_same_user
    if current_user != @article.user && !current_user.role.include?('admin')
      redirect_to @article, warning: "You can only edit of delete your own articles."
    end
  end
end