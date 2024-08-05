class SessionsController < ApplicationController
    before_action :check_user_logged_in, only: [:new]

    def new
    end

    def create
        user = User.find_by(:email => params[:session][:email].downcase)
        password = params[:session][:password]
        if user && user.authenticate(password)
            session[:user_id] = user.id
            redirect_to user_path(user), notice: "Logged in successfully."
        else
            flash.now[:alert] = "Wrong details entered. Please enter correct details"
            render 'new', status: 422
        end
    end

    def destroy
        if session[:user_id] != nil then session[:user_id] = nil end
        redirect_to root_path, notice: "Logged Out"
    end

    private

    def check_user_logged_in
        if session[:user_id] != nil then redirect_to root_path end
    end

end