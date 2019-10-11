class CurrencyPairsController < ApplicationController
  before_action :set_currency_pair, only: [:show, :edit, :update, :destroy]

  # GET /currency_pairs
  # GET /currency_pairs.json
  def index
    @currency_pairs = CurrencyPair.all
  end

  # GET /currency_pairs/1
  # GET /currency_pairs/1.json
  def show
  end

  # GET /currency_pairs/new
  def new
    @currency_pair = CurrencyPair.new
  end

  # GET /currency_pairs/1/edit
  def edit
  end

  # POST /currency_pairs
  # POST /currency_pairs.json
  def create
    @currency_pair = CurrencyPair.new(currency_pair_params)

    respond_to do |format|
      if @currency_pair.save
        format.html { redirect_to @currency_pair, notice: 'Currency pair was successfully created.' }
        format.json { render :show, status: :created, location: @currency_pair }
      else
        format.html { render :new }
        format.json { render json: @currency_pair.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /currency_pairs/1
  # PATCH/PUT /currency_pairs/1.json
  def update
    respond_to do |format|
      if @currency_pair.update(currency_pair_params)
        format.html { redirect_to @currency_pair, notice: 'Currency pair was successfully updated.' }
        format.json { render :show, status: :ok, location: @currency_pair }
      else
        format.html { render :edit }
        format.json { render json: @currency_pair.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /currency_pairs/1
  # DELETE /currency_pairs/1.json
  def destroy
    @currency_pair.destroy
    respond_to do |format|
      format.html { redirect_to currency_pairs_url, notice: 'Currency pair was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_currency_pair
      @currency_pair = CurrencyPair.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def currency_pair_params
      params.require(:currency_pair).permit(:name, :slug, :base_id, :quote_id, :winrate, :country, :desciption, :tag_id)
    end
end
