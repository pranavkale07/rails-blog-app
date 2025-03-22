class HomeController < ApplicationController
  def index
    @blogs = Blog.order(created_at: :desc).limit(3) # Fetch latest 3 blogs
  end
end
