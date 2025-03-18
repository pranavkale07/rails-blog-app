require "prawn"
class BlogsController < ApplicationController
    before_action :set_blog, only: [:show, :edit, :update, :destroy]
    before_action :require_login, only: [:new, :create, :edit, :update, :destroy]
    before_action :require_correct_author, only: [:edit, :update, :destroy]


    def index
        @blogs = Blog.all.order(created_at: :desc)  # List all blogs, newest first
    end

    def show
        respond_to do |format|
            format.html  # Renders show.html.erb
            format.pdf do
                pdf = generate_pdf(@blog) # Call a helper method to generate PDF
                send_data pdf.render,
                          filename: "#{@blog.title.parameterize}.pdf",
                          type: "application/pdf",
                          disposition: "inline" # "attachment" to force download
            end
        end
    end

    def new
        @blog = Blog.new
    end

    def create
        @blog = current_user.blogs.build(blog_params)
        
        if @blog.save
            flash[:notice] = "Blog created successfully!"
            redirect_to @blog
        else
            puts @blog.errors.full_messages  # Debugging output
            flash[:alert] = "Failed to create blog: #{@blog.errors.full_messages.join(", ")}"
            render :new, status: :unprocessable_entity
        end
    end

    def edit
        # empty bcz our before_action require_correct_user takes care of the correct user
    end

    def update
        if @blog.update(blog_params)
            flash[:notice] = "Blog updated successfully!"
            redirect_to @blog
        else
            flash[:alert] = "Something went wrong!"
            render :edit, status: :unprocessable_entity
        end
    end

    def destroy
        @blog.destroy
        flash[:notice] = "Blog deleted successfully!"
        redirect_to blogs_path
    end


    private

    def set_blog
        @blog = Blog.find(params[:id])
        rescue ActiveRecord::RecordNotFound
            flash[:alert] = "Blog not found"
            redirect_to blogs_path
    end

    def blog_params
        params.require(:blog).permit(:title, :content)
    end

    def require_correct_author
        @blog = Blog.find(params[:id])
        unless current_user == @blog.user
          flash[:alert] = "You are not authorized to edit this blog!"
          redirect_to blogs_path
        end
    end


    def generate_pdf(blog)
        Prawn::Document.new do
          text blog.title, size: 20, style: :bold
          move_down 10
          text blog.content, size: 12
        end
    end

end
