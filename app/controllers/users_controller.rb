class UsersController < ApplicationController

    before_action :set_user, only: [:show, :edit, :update, :destroy]
    before_action :require_login, only: [:edit, :update, :destroy]
    before_action :require_correct_author, only: [:edit, :update, :destroy]
    
    def new
        @user = User.new
    end
    
    def create
        @user = User.new(user_params)
        if(@user.save)
            session[:user_id] = @user.id
            flash[:notice] = "Welcome, #{@user.username}!"
            redirect_to @user
        else
            render :new, status: :unprocessable_entity
        end
    end
    
    def show
    end

    def edit
    end

    def update
        if(@user.update(user_params))
            flash[:notice] = "Profile updated successfully!"
            redirect_to @user
        else
            render :edit, status: :unprocessable_entity
        end
    end

    def destroy
        @user.destroy
        session[:user_id] = nil
        redirect_to root_path, notice: "Account deleted successfully!"
    end

    def login
        # This renders the login form
    end

    def create_session
        user = User.find_by(email: params[:session][:email].downcase)
        if user && user.authenticate(params[:session][:password])
            session[:user_id] = user.id
            flash[:notice] = "Logged in successfully"
            redirect_to user
        else
            flash.now[:alert] = "Invalid email or password"
            render :login, status: :unprocessable_entity
        end
    end

    def logout
        session[:user_id] = nil
        flash[:notice] = "Logged out successfully"
        redirect_to root_path
    end

    private
        def user_params
            params.require(:user).permit(:username, :email, :password) 
        end

        def set_user
            @user = User.find_by(id: params[:id])
            unless @user
                flash[:alert] = "User not found"
                redirect_to root_path
            end
        end

        # def authenticate_user
        #     redirect_to login_path, alert: "You must be logged in to perform this action" unless current_user
        # end


end
