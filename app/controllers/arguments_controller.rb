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
    create_statement

    respond_to do |format|
      if @argument.save
        format.html { redirect_to action: after_update_action }
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
    create_statement
    respond_to do |format|
      if @argument.update(argument_params)
        format.html { redirect_to action: after_update_action, notice: 'Argument was successfully updated.' }
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
    # Use callbacks to share common setup or constraints between actions.
    def set_argument
      @argument = Argument.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def argument_params
      params.require(:argument).permit(:text, :agree, :statement_id, :statement_text)
    end

    def after_update_action
      if params[:edit_action] == 'add_another'
        :edit
      else
        :show
      end
    end

    def create_statement
      if (new_statement = params[:new_statement_text]).present?
        @argument.premises << Statement.create(text: new_statement)
        params[:new_statement_text] = nil
      end
    end
end
