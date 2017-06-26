module Abilities
  class Everyone
    include CanCan::Ability

    def initialize(user)
      can [:read, :map], Debate
      can [:read, :map, :summary], Proposal
      can :read, Comment
      can [:read, :welcome], Budget
      can :read, Budget::Investment
      can :read, SpendingProposal
      if Setting["feature.spending_proposal_features.open_results_page"].present?
        can [:stats, :results], SpendingProposal
      end
      can :read, Legislation
      can :read, User
      can [:search, :read], Annotation
      can [:read], Budget
      can [:read, :results], Budget
      can [:read], Budget::Group
      can [:read, :print], Budget::Investment
      can :new, DirectMessage
    end
  end
end
