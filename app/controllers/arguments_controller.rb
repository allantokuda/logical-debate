class ArgumentsController < ApplicationController
  before_action :set_argument, only: [:show, :edit, :update, :destroy]

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
    @statement = Statement.find(params[:statement_id])
    new_params = params.permit(:statement_id, :agree)
    @argument = Argument.new(statement: @statement, agree: new_params[:agree])
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
        format.html { redirect_to @argument }
        format.json { render :show, status: :created, location: @argument }
      else
        format.html { render :new }
        format.json { render json: @argument.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /arguments/1
  # PATCH/PUT /arguments/1.json
  def update
    create_premise

    success = premise_params.all? do |premise_id, premise_text|
      if premise_text.present?
        Statement.find(premise_id).update(text: premise_text)
      else
        PremiseCitation.find_by(statement_id: premise_id, argument_id: @argument.id)&.destroy
      end
    end

    respond_to do |format|
      if success && @argument.update(argument_params)
        format.html { redirect_to @argument, notice: 'Argument was successfully updated.' }
        format.json { render :show, status: :ok }
      else
        format.html { render :edit }
        format.json { render json: @argument.errors, status: :unprocessable_entity }
      end
    end
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
      params.require(:argument).permit(:text, :agree, :statement_id)
    end

    def premise_params
      params.permit(:premises => @argument.premises.map(&:id).map(&:to_s)).fetch(:premises, {})
    end

    def new_premise
      params.permit(:new_premise).fetch(:new_premise, nil)
    end

    def create_premise
      @argument.premises << Statement.create(text: new_premise) if new_premise.present?
    end
end
