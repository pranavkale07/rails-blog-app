class CommentsController < ApplicationController
    before_action :require_login
    before_action :set_blog
    before_action :set_comment, only: [:destroy]
    before_action :require_correct_commenter, only: [:destroy]


    def create
        @comment = @blog.comments.build(comment_params)
        @comment.user = current_user
    
        if @comment.save
          flash[:notice] = "Comment added!"
        else
          flash[:alert] = "Error adding comment."
        end
        redirect_to @blog
    end

    def destroy
        @comment.destroy
        flash[:notice] = "Comment deleted!"
        redirect_to @blog
    end   


    private

    def set_blog
        @blog = Blog.find(params[:blog_id])
    end

    def set_comment
        @comment = @blog.comments.find(params[:id])
    end

    def require_correct_commenter
        unless @comment.user == current_user
        flash[:alert] = "You are not authorized to delete this comment!"
        redirect_to @blog
        end
    end

    def comment_params
        params.require(:comment).permit(:message)
    end
end
