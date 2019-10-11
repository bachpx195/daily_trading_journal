class SymbolfxesController < ApplicationController
  before_action :set_symbolfx, only: [:show, :edit, :update, :destroy]

  # GET /symbolfxes
  # GET /symbolfxes.json
  def index
    @symbolfxes = Symbolfx.all
  end

  # GET /symbolfxes/1
  # GET /symbolfxes/1.json
  def show
  end

  # GET /symbolfxes/new
  def new
    @symbolfx = Symbolfx.new
  end

  # GET /symbolfxes/1/edit
  def edit
  end

  # POST /symbolfxes
  # POST /symbolfxes.json
  def create
    @symbolfx = Symbolfx.new(symbolfx_params)

    respond_to do |format|
      if @symbolfx.save
        format.html { redirect_to symbolfxes_url, notice: 'Symbolfx was successfully created.' }
        format.json { render :show, status: :created, location: @symbolfx }
      else
        format.html { render :new }
        format.json { render json: @symbolfx.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /symbolfxes/1
  # PATCH/PUT /symbolfxes/1.json
  def update
    respond_to do |format|
      if @symbolfx.update(symbolfx_params)
        format.html { redirect_to symbolfxes_url, notice: 'Symbolfx was successfully updated.' }
        format.json { render :index, status: :ok, location: @symbolfx }
      else
        format.html { render :edit }
        format.json { render json: @symbolfx.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /symbolfxes/1
  # DELETE /symbolfxes/1.json
  def destroy
    @symbolfx.destroy
    respond_to do |format|
      format.html { redirect_to symbolfxes_url, notice: 'Symbolfx was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_symbolfx
      @symbolfx = Symbolfx.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def symbolfx_params
      params.require(:symbolfx).permit(:name, :slug, :country, :desciption, :tag_id)
    end
end