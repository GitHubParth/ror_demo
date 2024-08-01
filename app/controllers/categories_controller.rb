class CategoriesController < ApplicationController
    before_action :find_category, only: [:show]
    before_action :require_admin, except: [:show, :index]
    
    def index
        @categories = Category.paginate(:page => params[:page], :per_page => 5)
    end

    def show
    end

    def new
        @category = Category.new
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