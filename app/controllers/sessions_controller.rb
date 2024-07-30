class SessionsController < ApplicationController
    before_action :check_user_logged_in, only: [:new]

    def new
    end

    def create
        user = User.find_by(:email => params[:session][:email].downcase)
        password = params[:session][:password]
        if user && user.authenticate(password)
            # if params[:session][:remember_me] == "1" do
                session[:user_id] = user.id
            # else
            #     session[:user_id] = ""
            # end
            flash.now[:notice] = "Logged in successfully."
            redirect_to user_path(user)
        else
            flash.now[:alert] = "Wrong details entered. Please enter correct details"
            render 'new', status: 422
        end
    end

    def destroy
        if session[:user_id] != nil then session[:user_id] = nil end
        flash[:notice] = "Logged Out"
        redirect_to root_path
    end

    private

    def check_user_logged_in
        if session[:user_id] != nil then redirect_to root_path end
    end

end