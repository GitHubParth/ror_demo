class CategoriesController < ApplicationController
    before_action :find_category, only: [:show, :edit, :update, :destroy]
    before_action :require_admin, except: [:show, :index]
    
    def index
        @categories = Category.paginate(:page => params[:page], :per_page => 5)
    end

    def show
        @articles = ArticleCategory.where(category_id: @category.id)
        @art_list = @articles.map { |a| a.article_id }
        @articles = Article.where(id: @art_list)
        @articles = @articles.paginate(:page => params[:page], :per_page => 5)
    end

    def new
        @category = Category.new
    end

    def edit
    end

    def create
        @category = Category.new(whitelist_params)
        if @category.save
            flash[:notice] = "New Category has been created successfully."
            redirect_to @category
        else
            render 'new', status: 422
        end
    end

    def update
        if @category.update(whitelist_params)
            flash[:notice] = "Category has been updated successfully."
            redirect_to @category
        else
            render 'edit', status: 442
        end
    end

    def destroy
        @category.destroy
        redirect_to categories_path
    end

    private

    def find_category
        @category = Category.find(params[:id])
    end

    def whitelist_params
        params.require(:category).permit(:name)
    end

    def require_admin
        if !(logged_in? && current_user.role.include?("admin"))
            flash[:alert] = "Only admins are allowed to add categories."
            redirect_to categories_path
        end
    end

end