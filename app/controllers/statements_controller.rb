class StatementsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_statement, only: [:show, :edit, :update, :destroy, :agree, :disagree, :no_stance, :agreements, :disagreements, :review_arguments]
  before_action :find_stance, only: [:show, :edit, :agree, :disagree, :agreements, :disagreements, :review_arguments]

  # GET /statements
  # GET /statements.json
  def index
    @statements = Statement.where(top_level: true)
  end

  # GET /statements/1
  # GET /statements/1.json
  def show
  end

  # GET /statements/new
  def new
    @statement = Statement.new
  end

  def new_response
    allowed_params = params.permit(:id, :agree, :statement)
    @statement = Statement.new(parent_statement_id: allowed_params[:id], agree: allowed_params[:agree] == 'true')
    render :new
  end

  # GET /statements/1/edit
  def edit
  end

  # POST /statements
  # POST /statements.json
  def create
    @statement = Statement.new(statement_params)
    @statement.user = current_user

    respond_to do |format|
      if @statement.save
        format.html { redirect_to @statement, notice: 'Statement was successfully created.' }
        format.json { render :show, status: :created, location: @statement }
      else
        format.html { render :new }
        format.json { render json: @statement.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /statements/1
  # PATCH/PUT /statements/1.json
  def update
    respond_to do |format|
      if @statement.update(statement_params)
        format.html { redirect_to @statement, notice: 'Statement was successfully updated.' }
        format.json { render :show, status: :ok, location: @statement }
      else
        format.html { render :edit }
        format.json { render json: @statement.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /statements/1
  # DELETE /statements/1.json
  def destroy
    @statement.destroy
    respond_to do |format|
      format.html { redirect_to statements_url, notice: 'Statement was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def agree
    Stance.new(statement: @statement, user: current_user, agree: true).save
    redirect_to agreements_statement_path(@statement)
  end

  def disagree
    Stance.new(statement: @statement, user: current_user, agree: false).save
    redirect_to disagreements_statement_path(@statement)
  end

  def no_stance
    Stance.where(statement: @statement, user: current_user).first&.destroy
    redirect_to @statement
  end

  def agreements
    @side = true
    existing_arguments(@side)
  end

  def disagreements
    @side = false
    existing_arguments(@side)
  end

  def existing_arguments(side)
    if @statement.arguments.where(agree: @side).published.any?
      render :arguments
    else
      redirect_to new_argument_path(@statement, argument: { subject_statement_id: @statement.id, agree: @side })
    end
  end

  def review_arguments
    review_params.fetch(:arguments, {}).each do |argument_id, value|
      next unless value == '1' && argument = Argument.find(argument_id)
      Vote.create(user: current_user, argument: argument)
    end

    if review_params[:other].present?
      redirect_to new_argument_path(@statement, argument: { subject_statement_id: @statement.id, agree: review_params[:agree].to_i == 1 })
    else
      redirect_to @statement
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def find_statement
      @statement = Statement.find(params[:id])
    end

    def find_stance
      @stance = Stance.where(user: current_user, statement: @statement).first
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def statement_params
      params.require(:statement).permit(:uuid, :text, :user_id, :parent_statement_id, :agree, :countered_argument_id, :top_level, :verified_one_sentence)
    end

    def review_params
      params.permit(:agree, :other, :arguments => @statement.arguments.map(&:id).map(&:to_s))
    end
end
