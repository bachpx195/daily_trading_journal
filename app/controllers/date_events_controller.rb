class DateEventsController < ApplicationController
  before_action :set_merchandise_rate, only: [:show, :edit, :update, :destroy]

  def index
    @merchandise_rates = MerchandiseRate.all
  end

  def show
    @commentable = @merchandise_rate
    @comments = @commentable.comments&.order('created_at DESC')
  end

  def new
    @merchandise_rate = MerchandiseRate.new
  end

  def edit
  end

  def create
    @merchandise_rate = MerchandiseRate.new(merchandise_rate_params)

    respond_to do |format|
      if @merchandise_rate.save
        format.html { redirect_to @merchandise_rate, notice: 'Currency pair was successfully created.' }
        format.json { render :index, status: :created, location: @merchandise_rate }
      else
        format.html { render :new }
        format.json { render json: @merchandise_rate.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @merchandise_rate.update(merchandise_rate_params)
        format.html { redirect_to @merchandise_rate, notice: 'Currency pair was successfully updated.' }
        format.json { render :index, status: :ok, location: @merchandise_rate }
      else
        format.html { render :edit }
        format.json { render json: @merchandise_rate.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @merchandise_rate.destroy
    respond_to do |format|
      format.html { redirect_to merchandise_rates_url, notice: 'Currency pair was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def event_masters
    merchandise_rate = MerchandiseRate.find(params[:merchandise_rate_id])
    @event_masters = merchandise_rate.event_masters
    
    respond_to do |format|
      format.js {render layout: false} # Add this line to you respond_to block
    end
  end


  private
    def set_merchandise_rate
      @merchandise_rate = MerchandiseRate.find(params[:id])
    end

    def merchandise_rate_params
      params[:merchandise_rate][:is_follow] = params[:merchandise_rate][:is_follow].to_i
      params.require(:merchandise_rate).permit(:name, :base_id, :quote_id, :winrate, :country, :desciption, :tag_id, :crosses_related, :liquid_rate, :brief, :spread, :is_follow)
    end
end
