class WikisController < ApplicationController
  before_action :set_wiki, only: [:show, :edit, :update, :destroy]

  # GET /wikis
  # GET /wikis.json
  def index
    @wikis = if params[:wiki_type].to_i == 0
               Wiki.crypto_and_common.paginate(page: params[:page])
             else
               Wiki.forex_and_common.paginate(page: params[:page])
             end
  end

  def show
  end

  # GET /wikis/new
  def new
    @wiki = Wiki.new
  end

  # GET /wikis/1/edit
  def edit
  end

  # POST /wikis
  # POST /wikis.json
  def create
    @wiki = Wiki.new(wiki_params)
    
    respond_to do |format|
      if @wiki.save
        format.html { redirect_to wikis_url(anchor: params[:root_tag].present? ? "tab-#{params[:root_tag]}" : ""), notice: 'Wiki was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end

  # PATCH/PUT /wikis/1
  # PATCH/PUT /wikis/1.json
  def update
    respond_to do |format|
      if @wiki.update(wiki_params)
        format.html { redirect_to wikis_url(anchor: params[:root_tag].present? ? "tab-#{params[:root_tag]}" : ""), notice: 'Wiki was successfully updated.' }
      else
        format.html { render :edit }
      end
    end
  end

  # DELETE /wikis/1
  # DELETE /wikis/1.json
  def destroy
    @wiki.destroy
    respond_to do |format|
      format.html { redirect_to wikis_url, notice: 'Wiki was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_wiki
      @wiki = Wiki.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def wiki_params
      params.require(:wiki).permit(:title, :content, :brief, :tag_id, :image)
    end
end
