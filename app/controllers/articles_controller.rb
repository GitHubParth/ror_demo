class ArticlesController < ApplicationController
  before_action :find_article, only: [:show, :edit, :update, :destroy]

  def show
  end

  def index
    @articles = Article.all
  end

  def new
    @article = Article.new
  end

  def edit
  end

  def create
    @article = Article.new(whitelist_params)
    @article.user = User.first
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
    redirect_to articles_path
  end

  private

  def find_article
    @article = Article.find(params[:id])
  end

  def whitelist_params
    params.require(:article).permit(:title, :description)
  end

end