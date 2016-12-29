class PremisesController < ApplicationController
  def index
    @premises = Premise.all
  end

  def show
    @premise = Premise.find(pc_params[:id])
  end

  private

  def pc_params
    params.permit(:id)
  end
end
