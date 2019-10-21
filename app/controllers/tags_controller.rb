class TagsController < ApplicationController
  before_action :set_tag, only: [:show, :edit, :update, :destroy]
  skip_before_action :verify_authenticity_token
  
  
  # GET /tags
  # GET /tags.json
  def index
  end
  
  # GET /tags/1
  # GET /tags/1.json
  def show
  end

  # GET /tags/new
  def new
    @tag = Tag.new
  end

  # GET /tags/1/edit
  def edit
  end

  # POST /tags
  # POST /tags.json
  def create
    @tag = Tag.new(tag_params)
    
    if @tag.save
      if params[:parent].present?
        parent = Tag.find_by id: params[:parent]
        if parent.present?
          @tag.move_to_child_of(parent)
          parent.reload
          Tag.find(1).reload
        end
      end
      
      flash[:notice] = "Updated"
      render :index
    end
  end

  # PATCH/PUT /tags/1
  # PATCH/PUT /tags/1.json
  def update
    if @tag.update tag_params
      flash[:notice] = "Updated"
      render :index
    else
      load_support
      flash[:alert] = "Failed"
      render :new
    end
  end

  # DELETE /tags/1
  # DELETE /tags/1.json
  def destroy
    @tag.destroy
    flash[:notice] = "Updated"
    render :index
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tag
      @tag = Tag.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def tag_params
      params.require(:tag).permit(:title, :slug, :content, :new_position, :parent_id, :is_follow)
    end

    def load_support
      @tag = TagSupport.new @tag
    end
end
