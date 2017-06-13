class Management::Budgets::BallotsController < Management::BaseController
  before_action :authenticate_user!
  load_and_authorize_resource :budget
  before_action :load_ballot, :load_group, :load_heading, :load_investments


  def new
    load_ballot
    redirect_to management_budget_ballot_path(@budget, @ballot)
  end

  def show
    authorize! :show, @ballot
    render template: "management/budgets/ballots/show"
  end

  private

  def load_ballot
    query = Budget::Ballot.where(user: current_user, budget: @budget)
    @ballot = @budget.balloting? ? query.first_or_create : query.first_or_initialize
  end

  #GET-107
  def load_group
    unless @ballot.group.nil?
      @group = @ballot.group
    else
      if params[:group_id]
        @group = @budget.groups.find(params[:group_id])
      end
    end
  end

  def load_heading
    if params[:heading_id]
      @heading = @group.headings.find(params[:heading_id])
    else
      if @group
        @heading = @group.headings.first
      end
    end
  end

  def load_investments
    if @group
      @investments = @budget.investments.where(group_id: @group.id, heading_id: @heading.id).where(selected: true)
    end
  end
end
