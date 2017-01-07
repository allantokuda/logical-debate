class ArgumentsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_argument, only: [:show, :edit, :update, :publish, :upvote, :remove_vote, :destroy, :suggest_new, :counter]
  before_action :new_argument, only: [:new, :create]
  before_action :new_premise, only: [:create, :update]
  after_action :publish_from_form, only: [:create, :update]

  # GET /arguments
  # GET /arguments.json
  def index
    redirect_to statements_path
  end

  # GET /arguments/1
  # GET /arguments/1.json
  def show
  end

  def suggest_new
  end

  # GET /arguments/new
  def new
  end

  # GET /arguments/1/edit
  def edit
  end

  # POST /arguments
  # POST /arguments.json
  def create
    ActiveRecord::Base.transaction do
      respond_to do |format|
        if !@argument.save
          format.html { render :new, alert: 'Failed to create argument.' }
          format.json { render json: @argument.errors, status: :unprocessable_entity }
        elsif @new_premise && !@new_premise.save
          format.html { render :new, alert: 'Failed to add premise to argument.' }
          format.json { render json: @new_premise.errors, status: :unprocessable_entity }
        else
          format.html { redirect_to after_update_view }
          format.json { render :show, status: :created, location: @argument }
        end
      end
    end
  end

  # PATCH/PUT /arguments/1
  # PATCH/PUT /arguments/1.json
  def update
    return fork_argument if @argument.published?
    ActiveRecord::Base.transaction do
      respond_to do |format|
        if !@argument.update(argument_params)
          format.html { render :edit, alert: 'Failed to update argument.' }
          format.json { render json: @argument.errors, status: :unprocessable_entity }
        elsif @new_premise && !@new_premise.save
          format.html { render :edit, alert: 'Failed to add premise to argument.' }
          format.json { render json: @new_premise.errors, status: :unprocessable_entity }
        elsif !Premise.bulk_update_from_params(update_premise_params)
          format.html { render :edit, alert: 'Failed to update existing premises.' }
          format.json { render json: @existing_premises.map(&:errors).flatten, status: :unprocessable_entity }
        else
          format.html { redirect_to after_update_view }
          format.json { render :show, status: :ok }
        end
      end
    end
  end

  def publish
    @argument.publish!
    redirect_to @argument
  end

  def upvote
    Vote.create(argument: @argument, user: current_user)
    redirect_to @argument.subject
  end

  def remove_vote
    Vote.find_by(argument: @argument, user: current_user).destroy
    redirect_to @argument.subject
  end

  def counter
    @statement = Statement.new(countered_argument_id: @argument.id)
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
    def find_argument
      @argument = Argument.find(params[:id])
    end

    def new_argument
      @argument = Argument.new(argument_params.merge(user: current_user))
    end

    def fork_argument
      new_argument = @argument.dup
      new_argument.user = current_user
      new_argument.parent_argument = @argument
      new_argument.published_at = nil
      new_argument.set_uuid
      update_premise_params.each do |_id, text|
        forked_statement = Statement.new(text: text, user: current_user)
        forked_premise = Premise.new(statement: forked_statement, argument: new_argument)
        new_argument.premises << forked_premise
      end
      @new_premise.argument = new_argument
      new_argument.premises << @new_premise if @new_premise.present?
      @argument = new_argument

      respond_to do |format|
        if !@argument.save
          format.html { render :suggest_new, alert: 'Failed to create suggested new argumen.' }
          format.json { render json: @argument.errors, status: :unprocessable_entity }
        else
          format.html { redirect_to after_update_view }
          format.json { render :show, status: :ok }
        end
      end
    end

    def argument_params
      params.require(:argument).permit(:uuid, :text, :agree, :subject_statement_id, :subject_premise_id)
    end

    def new_premise
      return unless (text = params.permit(:new_premise).fetch(:new_premise, nil)).present?
      @new_premise = Premise.new(
        argument: @argument,
        statement: Statement.new(
          text: text,
          user: current_user
        )
      )
    end

    def update_premise_params
      params.permit(:premises => @argument.premises.map(&:id).map(&:to_s)).fetch(:premises, {})
    end

    def save_action
      params.permit(:save_action).fetch(:save_action, nil)
    end

    def after_update_view
      case save_action
      when 'save_and_add'
        edit_argument_path(@argument)
      when 'publish'
        @argument.subject
      else
        argument_path(@argument)
      end
    end

    def publish_from_form
      @argument.publish! if save_action == 'publish'
    end
end
