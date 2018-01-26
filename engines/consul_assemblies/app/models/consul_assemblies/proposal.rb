module ConsulAssemblies
  class Proposal < ActiveRecord::Base

    belongs_to :meeting
    belongs_to :user
    has_many :attachments, as: :attachable

    before_validation :sanitize_conclusion

    validates :title, presence: true
    validates :meeting, presence: true

    accepts_nested_attributes_for :attachments,  :reject_if => :all_blank, :allow_destroy => true

    scope :accepted, -> { where(accepted: true) }
    scope :declined, -> { where(accepted: false).where(is_previous_meeting_acceptance: false) }
    scope :pending, -> { where(accepted: nil) }
    scope :to_approve, -> { where(is_previous_meeting_acceptance: true) }
    acts_as_list scope: :meeting

    def conclusion
      super.try :html_safe
    end

    def sanitize_conclusion
      self.conclusion = WYSIWYGSanitizer.new.sanitize(conclusion)
    end

    def archived?
      false
    end
  end
end
