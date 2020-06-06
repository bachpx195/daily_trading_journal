class PlansController < ApplicationController
  before_action :set_plan, only: [:show, :edit, :update, :destroy]
  skip_before_action :verify_authenticity_token
  
  # GET /plans
  # GET /plans.json
  def index
  end
  
  # GET /plans/1
  # GET /plans/1.json
  def show
  end

  # GET /plans/new
  def new
    @plan = Plan.new
  end

  # GET /plans/1/edit
  def edit
  end

  # POST /plans
  # POST /plans.json
  def create
    @plan = Plan.new(plan_params)
    
    if @plan.save
      if params[:parent].present?
        parent = Plan.find_by id: params[:parent]
        if parent.present?
          @plan.move_to_child_of(parent)
          parent.reload
          Plan.find(1).reload
        end
      end
      
      flash[:notice] = "Updated"
      render :index
    end
  end

  # PATCH/PUT /plans/1
  # PATCH/PUT /plans/1.json
  def update
    if @plan.update plan_params
      flash[:notice] = "Updated"
      redirect_to plans_url
    else
      load_support
      flash[:alert] = "Failed"
      render :new
    end
  end

  # DELETE /plans/1
  # DELETE /plans/1.json
  def destroy
    @plan.destroy
    flash[:notice] = "Updated"
    render :index
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_plan
      @plan = Plan.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def plan_params
      params[:plan][:is_follow] = params[:plan][:is_follow].to_i
      params.require(:plan).permit(:title, :new_position, :parent_id)
    end

    def load_support
      @plan = PlanSupport.new @plan
    end
end
