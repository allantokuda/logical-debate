class PremisesController < ApplicationController
  before_action :find_premise, except: [:index]

  def index
    @premises = Premise.all
  end

  def show
  end

  def agree
    respond(true)
  end

  def disagree
    respond(false)
  end

  private

  def find_premise
    @premise = Premise.find(premise_params[:id])
  end

  def respond(agree)
    redirect_to new_argument_path(subject_premise_id: @premise.id, agree: agree)
  end

  def premise_params
    params.permit(:id)
  end
end
