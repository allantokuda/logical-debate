class PremiseCitationsController < ApplicationController
  def index
    @premise_citations = PremiseCitation.all
  end

  def show
    @premise_citation = PremiseCitation.find(pc_params[:id])
  end

  private

  def pc_params
    params.permit(:id)
  end
end
