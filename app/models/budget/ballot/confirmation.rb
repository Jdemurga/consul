class Budget
  class Ballot
    class  Confirmation < ActiveRecord::Base

      belongs_to :ballot
      belongs_to :group
      belongs_to :budget
      belongs_to :user, class_name: 'User' #Ballot Owner

      acts_as_paranoid column: :discarted_at

      belongs_to :confirmed_by_user, class_name: 'User' # User who perform the action
      belongs_to :discarted_by_user, class_name: 'User' # User who perform the action

      validates :ballot_summary, presence: true
      validates :ballot, presence: true
      validates :group, presence: true
      validates :confirmed_at, presence: true
      validates :confirmed_by_user_name, presence: true
      validates :confirmed_by_user_id, presence: true
      validate :only_one_confirmed_ballot_at_same_time

      scope :confirmed, -> { where(discarted_at: nil) }

      def deliver_sms_confirmation
        if phone_number
          SMSApiCustom.new.ballot_confirm_sms_deliver(phone_number, I18n.t('budgets.ballot_confirmation_sms_body'))
        end
      end
      def only_one_confirmed_ballot_at_same_time
        return if discarted_at
        if Budget::Ballot::Confirmation.where(ballot_id: ballot_id, discarted_at: nil).any?
          errors.add(:ballot, :already_confirmed)
        end
      end
    end
  end
end
