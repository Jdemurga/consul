class BudgetsController < ApplicationController
  include FeatureFlags
  feature_flag :budgets


  load_and_authorize_resource
  respond_to :html, :js

  def show
  end

  def index
    @budgets = @budgets.order(:created_at)
    redirect_to @budgets.last
  end

  def results
    if params[:group_id]
      @group = @budget.groups.find(params[:group_id])
    else
      @group = @budget.groups.first if @budget.groups.any?
    end

    @ballots = @budget.ballots.where.not(user_id: nil).joins(:user).where('users.verified_at IS NOT NULL').order('created_at desc')

    @all_confirmations_on_budget = Budget::Ballot::Confirmation.where(budget_id: @budget.id, discarted_at: nil)
                             .joins(:ballot)
                             .joins('LEFT JOIN budget_ballot_lines ON budget_ballots.id = budget_ballot_lines.ballot_id')
                             .uniq('budget_ballot_confirmations.id')

    @valid_confirmations_on_budget = Budget::Ballot::Confirmation.where(budget_id: @budget.id, discarted_at: nil).where.not(confirmed_at: nil)
                                       .joins(:ballot)
                                       .joins('LEFT JOIN budget_ballot_lines ON budget_ballots.id = budget_ballot_lines.ballot_id')
                                       .uniq('budget_ballot_confirmations.id')

    @not_valid_confirmations_on_budget = Budget::Ballot::Confirmation.where(budget_id: @budget.id, discarted_at: nil).where(confirmed_at: nil)
                                         .joins(:ballot)
                                         .joins('LEFT JOIN budget_ballot_lines ON budget_ballots.id = budget_ballot_lines.ballot_id')
                                         .uniq('budget_ballot_confirmations.id')


    @all_confirmations = Budget::Ballot::Confirmation.where(budget_id: @budget.id, discarted_at: nil, group_id: @group.id)
                         .joins(:ballot)
                         .joins('LEFT JOIN budget_ballot_lines ON budget_ballots.id = budget_ballot_lines.ballot_id')
                         .uniq('budget_ballot_confirmations.id')

    @valid_confirmations = Budget::Ballot::Confirmation.where(budget_id: @budget.id, discarted_at: nil, group_id: @group.id)
                         .where.not(confirmed_at: nil)
                         .joins(:ballot)
                         .joins('LEFT JOIN budget_ballot_lines ON budget_ballots.id = budget_ballot_lines.ballot_id')
                         .uniq('budget_ballot_confirmations.id')

    @not_valid_confirmations = Budget::Ballot::Confirmation.where(budget_id: @budget.id, discarted_at: nil, group_id: @group.id)
                         .where(confirmed_at: nil)
                         .joins(:ballot)
                         .joins('LEFT JOIN budget_ballot_lines ON budget_ballots.id = budget_ballot_lines.ballot_id')
                         .uniq('budget_ballot_confirmations.id')

  end
end
