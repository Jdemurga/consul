require_dependency Rails.root.join('app', 'models', 'budget', 'investment').to_s

class Budget
  class Investment < ActiveRecord::Base

    mount_uploader :attachment, AttachmentUploader

    validates :attachment, file_size: { less_than: 5.megabytes }

    def verify_attachment!(user)
      update!(attachment_verified: true, attachment_verified_by: user.username)
    end

    def has_attachment?
      !attachment.blank?
    end

    def attachment_verified?
      attachment_verified == true
    end
  end
end
