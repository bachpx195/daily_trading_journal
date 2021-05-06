class CurrencyPairsController < ApplicationController
  before_action :set_currency_pair, only: [:show, :edit, :update, :destroy]

  def index
    @currency_pairs = CurrencyPair.all
  end

  def show
    @commentable = @currency_pair
    @comments = @commentable.comments&.order('created_at DESC')
  end

  def new
    @currency_pair = CurrencyPair.new
  end

  def edit
  end

  def create
    @currency_pair = CurrencyPair.new(currency_pair_params)

    respond_to do |format|
      if @currency_pair.save
        format.html { redirect_to @currency_pair, notice: 'Currency pair was successfully created.' }
        format.json { render :index, status: :created, location: @currency_pair }
      else
        format.html { render :new }
        format.json { render json: @currency_pair.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @currency_pair.update(currency_pair_params)
        format.html { redirect_to @currency_pair, notice: 'Currency pair was successfully updated.' }
        format.json { render :index, status: :ok, location: @currency_pair }
      else
        format.html { render :edit }
        format.json { render json: @currency_pair.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @currency_pair.destroy
    respond_to do |format|
      format.html { redirect_to currency_pairs_url, notice: 'Currency pair was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def set_currency_pair
      @currency_pair = CurrencyPair.find(params[:id])
    end

    def currency_pair_params
      params[:currency_pair][:is_follow] = params[:currency_pair][:is_follow].to_i
      params.require(:currency_pair).permit(:name, :slug, :base_id, :quote_id, :winrate, :country, :desciption, :tag_id, :crosses_related, :liquid_rate, :brief, :spread, :is_follow)
    end
end
