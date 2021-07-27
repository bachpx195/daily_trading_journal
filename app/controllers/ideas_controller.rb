class IdeasController < ApplicationController
  before_action :set_idea, only: %i[ show edit update destroy ]

  # GET /ideas or /ideas.json
  def index
    @ideas = Idea.all
  end

  # GET /ideas/1 or /ideas/1.json
  def show
  end

  # GET /ideas/new
  def new
    @idea = Idea.new
  end

  # GET /ideas/1/edit
  def edit
  end

  # POST /ideas or /ideas.json
  def create
    @idea = Idea.new(idea_params)

    respond_to do |format|
      if @idea.save
        anchor = params[:root_tag].present? ? "tab-#{params[:root_tag]}" : ""
        format.html { redirect_to ideas_url(anchor: anchor), notice: 'Idea was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end

  # PATCH/PUT /ideas/1 or /ideas/1.json
  def update
    respond_to do |format|
      if @idea.update(idea_params)
        anchor = params[:root_tag].present? ? "tab-#{params[:root_tag]}" : ""
        format.html { redirect_to ideas_url(anchor: anchor), notice: 'Idea was successfully updated.' }
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /ideas/1 or /ideas/1.json
  def destroy
    @idea.destroy
    respond_to do |format|
      format.html { redirect_to ideas_url, notice: "Idea was successfully destroyed." }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_idea
      @idea = Idea.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def idea_params
      params.require(:ideas).permit(:title, :content, :brief, :tag_id, :image)
    end
end
