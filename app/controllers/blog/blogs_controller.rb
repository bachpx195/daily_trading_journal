class Blog::BlogsController < Blog::BaseBlogController
  before_action :set_blog, only: [:show]

  def index
  end

  def show
  end

  private
  def set_blog
    @blog = Blog.find(params[:id])
  end
end
