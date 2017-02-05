class CountersController < ApplicationController
  before_action :authenticate_user!
  before_action :find_argument
  before_action :find_fallacy

  def new
  end

  def create
    statement = Statement.new(countered_argument: @argument, text: counter_params[:custom_text].presence || @fallacy.as_statement, user: current_user)
    if statement.save
      redirect_to statement, notice: 'Counter saved successfully.'
    else
      redirect_to new_counter_argument_path(@argument, fallacy_name: counter_params[:fallacy_name]), alert: statement.errors.full_messages.join(', ')
    end
  end

  private

    def find_argument
      @argument = Argument.find(params[:id])
    end

    def find_fallacy
      @fallacy = Fallacy.find_by_name(counter_params[:fallacy_name])
    end

    def counter_params
      params.permit(:argument_id, :fallacy_name, :custom_text)
    end
end
