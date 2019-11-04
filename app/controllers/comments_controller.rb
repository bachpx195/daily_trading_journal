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
      if params[:comment][:commmentable] == 'CurrencyPair'
        redirect_to currency_pair_path(@commentable)
      elsif params[:comment][:commmentable] == 'Symbolfx'
        redirect_to symbolfx_path(@commentable)
      end
    end
  end
  
  private
  def load_commentable
    id = params[:comment][:commmentable_id]
    resource = params[:comment][:commmentable]
    
    @commentable = resource.singularize.classify.constantize.find(id)
  end
  
  def comment_params
    params[:comment][:is_importand] = params[:comment][:is_importand].to_i
    params.require(:comment).permit(:content, :is_importand)
  end
end