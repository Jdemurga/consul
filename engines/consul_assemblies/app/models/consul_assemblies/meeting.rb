module ConsulAssemblies
  class Meeting < ActiveRecord::Base
    include Flaggable
    include Taggable


    VALID_STATUSES = %w{open closed}

    belongs_to :assembly
    has_many :attachments, as: :attachable
    has_many :proposals

    validate :published_at_must_be_before_scheduled_at
    validates :assembly, presence: true, associated: true
    validates :description, presence: true

    mount_uploader :attachment, AttachmentUploader


    accepts_nested_attributes_for :attachments,  :reject_if => :all_blank, :allow_destroy => true

    scope :order_by_scheduled_at,  -> { order(scheduled_at: 'desc') }

    def ready_for_held?
      Time.current >= close_accepting_proposals_at  && Time.current < scheduled_at
    end

    def accepting_proposals?
      Time.current < close_accepting_proposals_at
    end

    def held?
      Time.current > scheduled_at
    end

    def published_at_must_be_before_scheduled_at
      errors.add(:published_at, 'no puede estar antes que la fecha programada') if published_at > scheduled_at
    end


    def archived?
      false
    end

    def comments_count
      0
    end
  end
end
