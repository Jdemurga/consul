class AddCustomFieldsToSpendingProposals < ActiveRecord::Migration
  def change

    add_column :spending_proposals, :spending_type, :string, null: nil
    add_column :spending_proposals, :phase_pre_bidding_at, :date
    add_column :spending_proposals, :phase_in_bidding_at, :date
    add_column :spending_proposals, :phase_in_progress_at, :date

  end
end
