class CoinLinksController < ApplicationController
  before_action :set_coin_link, only: [:show, :edit, :update, :destroy]

  # GET /coin_links
  # GET /coin_links.json
  def index
    @coin_links = CoinLink.all
  end

  # GET /coin_links/1
  # GET /coin_links/1.json
  def show
  end

  # GET /coin_links/new
  def new
    @coin_link = CoinLink.new
  end

  # GET /coin_links/1/edit
  def edit
  end

  # POST /coin_links
  # POST /coin_links.json
  def create
    @coin_link = CoinLink.new(coin_link_params)

    respond_to do |format|
      if @coin_link.save
        format.html { redirect_to @coin_link, notice: 'Coin link was successfully created.' }
        format.json { render :show, status: :created, location: @coin_link }
      else
        format.html { render :new }
        format.json { render json: @coin_link.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /coin_links/1
  # PATCH/PUT /coin_links/1.json
  def update
    respond_to do |format|
      if @coin_link.update(coin_link_params)
        format.html { redirect_to @coin_link, notice: 'Coin link was successfully updated.' }
        format.json { render :show, status: :ok, location: @coin_link }
      else
        format.html { render :edit }
        format.json { render json: @coin_link.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /coin_links/1
  # DELETE /coin_links/1.json
  def destroy
    @coin_link.destroy
    respond_to do |format|
      format.html { redirect_to coin_links_url, notice: 'Coin link was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_coin_link
      @coin_link = CoinLink.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def coin_link_params
      params.require(:coin_link).permit(:url, :kind, :coin)
    end
end
