module Abilities
  class Valuator
    include CanCan::Ability

    def initialize(user)
      valuator = user.valuator
      can [:read, :update, :valuate], SpendingProposal
      can [:read, :update, :valuate], Budget::Investment, id: valuator.investment_ids
      cannot [:update, :valuate], Budget::Investment, budget: { phase: 'finished' }
      can :mark_as_finished_own_valuation, Budget::Investment, id: valuator.investment_ids
    end
  end
end
