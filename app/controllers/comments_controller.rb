class CommentsController < ApplicationController
  before_action :load_commentable

  def index
    @comments = @commentable.comments
  end

  def new
    @comment = @commentable.comments.new

  end

  def create
    @comment = @commentable.comments.new comment_params
    if @comment.save
      if params[:comment][:commentable] == 'MerchandiseRate'
        redirect_to merchandise_rate_path(@commentable)
      elsif params[:comment][:commentable] == 'Merchandise'
        redirect_to merchandise_path(@commentable)
      elsif params[:comment][:commentable] == 'Idea'
        redirect_to idea_path(@commentable)
      elsif params[:comment][:commentable] == 'Trade'
        redirect_to trade_path(@commentable)
      end
    end
  end

  private
  def load_commentable
    id = params[:comment][:commentable_id]
    resource = params[:comment][:commentable]

    @commentable = resource.singularize.classify.constantize.find(id)
  end

  def comment_params
    params[:comment][:is_importand] = params[:comment][:is_importand].to_i
    params.require(:comment).permit(:content, :is_importand)
  end
end
