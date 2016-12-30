class ArgumentsController < ApplicationController
  before_action :set_argument, only: [:show, :edit, :update, :publish, :destroy]

  # GET /arguments
  # GET /arguments.json
  def index
    @arguments = Argument.all
  end

  # GET /arguments/1
  # GET /arguments/1.json
  def show
  end

  # GET /arguments/new
  def new
    @argument = Argument.from_params(params.permit(:subject_statement_id, :subject_premise_id, :agree))
  end

  # GET /arguments/1/edit
  def edit
  end

  # POST /arguments
  # POST /arguments.json
  def create
    @argument = Argument.new(argument_params)
    create_premise

    respond_to do |format|
      if @argument.save
        format.html { redirect_to after_update_view }
        format.json { render :show, status: :created, location: @argument }
      else
        format.html { render :new, notice: 'Failed to create argument.' }
        format.json { render json: @argument.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /arguments/1
  # PATCH/PUT /arguments/1.json
  def update
    create_premise

    success = premise_params.all? do |premise_id, premise_text|
      next unless premise = Premise.find(premise_id)
      if premise_text.present?
        premise.statement.update(text: premise_text)
      else
        premise.destroy
      end
    end

    respond_to do |format|
      if success && @argument.update(argument_params)
        format.html { redirect_to after_update_view }
        format.json { render :show, status: :ok }
      else
        format.html { render :edit }
        format.json { render json: @argument.errors, status: :unprocessable_entity }
      end
    end
  end

  def publish
    @argument.publish!
    redirect_to @argument
  end

  # DELETE /arguments/1
  # DELETE /arguments/1.json
  def destroy
    @argument.destroy
    respond_to do |format|
      format.html { redirect_to arguments_url, notice: 'Argument was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def set_argument
      @argument = Argument.find(params[:id])
    end

    def argument_params
      params.require(:argument).permit(:text, :agree, :subject_statement_id, :subject_premise_id)
    end

    def premise_params
      params.permit(:premises => @argument.premises.map(&:id).map(&:to_s)).fetch(:premises, {})
    end

    def after_update_view
      if params.permit(:update_action).fetch(:update_action, nil) == 'save_and_add'
        edit_argument_path(@argument)
      else
        @argument
      end
    end

    def new_premise
      params.permit(:new_premise).fetch(:new_premise, nil)
    end

    def create_premise
      if new_premise.present?
        premise = Premise.new
        premise.statement = Statement.create(text: new_premise)
        @argument.premises << premise
      end
    end
end
