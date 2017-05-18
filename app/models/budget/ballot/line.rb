class Budget
  class Ballot
    class Line < ActiveRecord::Base

      POINTS = [1, 2, 3]

      belongs_to :ballot
      belongs_to :investment
      belongs_to :heading
      belongs_to :group
      belongs_to :budget

      validates :ballot_id, :investment_id, :heading_id, :group_id, :budget_id, presence: true

      validate :check_selected
      validate :check_sufficient_funds
      validate :check_valid_heading
      validates :points, presence: true, uniqueness: { scope: [:budget_id, :ballot_id] }, numericality: { only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 3}
      validates :investment_id, presence: true, uniqueness: { scope: [:budget_id, :ballot_id] }

      before_validation :set_denormalized_ids

      def check_sufficient_funds
        errors.add(:money, "insufficient funds") if ballot.amount_available(investment.heading) < investment.price.to_i
      end

      def check_valid_heading
        return #GET-107
        errors.add(:heading, "This heading's budget is invalid, or a heading on the same group was already selected") unless ballot.valid_heading?(self.heading)
      end

      def check_selected
        errors.add(:investment, "unselected investment") unless investment.selected?
      end

      private

        def set_denormalized_ids
          self.heading_id ||= self.investment.try(:heading_id)
          self.group_id   ||= self.investment.try(:group_id)
          self.budget_id  ||= self.investment.try(:budget_id)
        end
    end
  end
end
