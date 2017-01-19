require_dependency Rails.root.join('app', 'models', 'budget', 'investment').to_s

class Budget
  class Investment < ActiveRecord::Base

    include Flaggable #GET-62 Moderable

    mount_uploader :attachment, AttachmentUploader

    validates :attachment, file_size: { less_than: 5.megabytes }

    scope :with_attachment_verified, -> { where.not(attachment: nil).where(attachment_verified: true).where(hidden_at: nil) }
    scope :with_pending_attachment_verification, -> { where.not(attachment: nil).where(attachment_verified: nil).where(hidden_at: nil) }
    scope :with_attachment_rejected, -> { where.not(attachment: nil).where(attachment_verified: false).where(hidden_at: nil) }
    scope :sort_by_created_at, -> { order('created_at asc') }
    scope :sort_by_created_at_desc, -> { order('created_at desc') }
    scope :pending_flag_review, -> { where(ignored_flag_at: nil, hidden_at: nil) }
    scope :with_ignored_flag, -> { where.not(ignored_flag_at: nil).where(hidden_at: nil) }

    def verify_attachment!(user)
      update!(attachment_verified: true, attachment_verified_by: user.username)
    end

    def reject_attachment!(user)
      update!(attachment_verified: false, attachment_verified_by: user.username)
    end

    def has_attachment?
      !attachment.blank?
    end

    def attachment_verified?
      attachment_verified == true
    end

    def attachment_rejected?
      attachment_verified == false
    end

    def attachment_pending?
      attachment_verified.nil?
    end
  end
end
