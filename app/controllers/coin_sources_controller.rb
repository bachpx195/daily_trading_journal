class CoinSourcesController < ApplicationController
  before_action :set_coin_source, only: [:show, :edit, :update, :destroy]

  # GET /coin_sources
  # GET /coin_sources.json
  def index
    @coin_sources = CoinSource.all
  end

  # GET /coin_sources/1
  # GET /coin_sources/1.json
  def show
  end

  # GET /coin_sources/new
  def new
    @coin_source = CoinSource.new
  end

  # GET /coin_sources/1/edit
  def edit
  end

  # POST /coin_sources
  # POST /coin_sources.json
  def create
    @coin_source = CoinSource.new(coin_source_params)

    respond_to do |format|
      if @coin_source.save
        format.html { redirect_to @coin_source, notice: 'Coin source was successfully created.' }
        format.json { render :show, status: :created, location: @coin_source }
      else
        format.html { render :new }
        format.json { render json: @coin_source.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /coin_sources/1
  # PATCH/PUT /coin_sources/1.json
  def update
    respond_to do |format|
      if @coin_source.update(coin_source_params)
        format.html { redirect_to @coin_source, notice: 'Coin source was successfully updated.' }
        format.json { render :show, status: :ok, location: @coin_source }
      else
        format.html { render :edit }
        format.json { render json: @coin_source.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /coin_sources/1
  # DELETE /coin_sources/1.json
  def destroy
    @coin_source.destroy
    respond_to do |format|
      format.html { redirect_to coin_sources_url, notice: 'Coin source was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_coin_source
      @coin_source = CoinSource.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def coin_source_params
      params.require(:coin_source).permit(:title, :domain_slug, :website, :coin)
    end
end
