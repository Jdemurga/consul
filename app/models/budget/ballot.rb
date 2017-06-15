class Budget
  class Ballot < ActiveRecord::Base

    MAX_LINES_PER_HEADING = 3 #GET-107

    belongs_to :user
    belongs_to :budget

    has_many :lines, dependent: :destroy
    has_many :investments, through: :lines
    has_many :groups, -> { uniq }, through: :lines
    has_many :headings, -> { uniq }, through: :lines

    #GET-107
    def group
      groups.first
    end

    def not_started?
      lines.empty?
    end

    def completed?
      if  group
        group.headings.all? { |h| completed_by_heading?(h) }
      end
    end

    def number_of_mandatory_lines
      if  group
        group.headings.inject(0) { |sum,h| number_of_mandatory_lines_to_complete(h) + sum }
      end
    end

    def completed_by_heading?(heading)

      number_remaining_lines_to_complete(heading) == 0
    end

    def number_remaining_lines_to_complete(heading)

      ballot_lines_count = lines.where(heading_id: heading.id).count
      number_of_mandatory_lines_to_complete(heading) - ballot_lines_count
    end

    def number_of_mandatory_lines_to_complete(heading)
      investments_count = heading.investments.selected.count
      [investments_count, MAX_LINES_PER_HEADING].min
    end

    def investment_points(investment)
      line  = lines.where(investment_id: investment.id).first
      line ? line.points : 0
    end

    def sorted_investments(heading_id = nil)
      investments = lines.order(:points).collect(&:investment)
      investments = investments.select { |investment| investment.heading_id == heading_id } if heading_id
      investments
    end

    def add_investment(investment)
      lines.create!(investment: investment)
    end

    def add_investment(investment, points)
      lines.create!(investment: investment, points: points)
    end

    def total_amount_spent
      investments.sum(:price).to_i
    end

    def amount_spent(heading)
      investments.by_heading(heading.id).sum(:price).to_i
    end

    def formatted_amount_spent(heading)
      budget.formatted_amount(amount_spent(heading))
    end

    def amount_available(heading)
      budget.heading_price(heading) - amount_spent(heading)
    end

    def formatted_amount_available(heading)
      budget.formatted_amount(amount_available(heading))
    end

    def has_lines_in_group?(group)
      self.groups.include?(group)
    end

    def wrong_budget?(heading)
      heading.budget_id != budget_id
    end

    def different_heading_assigned?(heading)
      other_heading_ids = heading.group.heading_ids - [heading.id]
      lines.where(heading_id: other_heading_ids).exists?
    end

    def valid_heading?(heading)
      !wrong_budget?(heading) && !different_heading_assigned?(heading)
    end

    def has_lines_with_no_heading?
      investments.no_heading.count > 0
    end

    def has_lines_with_heading?
      self.heading_id.present?
    end

    def has_lines_in_heading?(heading)
      investments.by_heading(heading.id).any?
    end

    def has_investment?(investment)
      self.investment_ids.include?(investment.id)
    end

    def heading_for_group(group)
      self.headings.where(group: group).first
    end

  end
end
