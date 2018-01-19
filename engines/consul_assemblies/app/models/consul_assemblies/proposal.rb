module ConsulAssemblies
  class Proposal < ActiveRecord::Base

    belongs_to :meeting
    belongs_to :user
    has_many :attachments, as: :attachable

    before_validation :sanitize_conclusion

    validates :title, presence: true

    accepts_nested_attributes_for :attachments,  :reject_if => :all_blank, :allow_destroy => true

    scope :accepted, -> { where(accepted: true) }
    scope :declined, -> { where(accepted: false) }
    scope :pending, -> { where(accepted: nil) }

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
