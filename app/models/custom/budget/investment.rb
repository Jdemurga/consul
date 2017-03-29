require_dependency Rails.root.join('app', 'models', 'budget', 'investment').to_s
require 'csv'

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

    #GET-98
    scope :not_unified, -> { where(unified_with_id: nil) }

    belongs_to :unified_with, class_name: 'Budget::Investment', foreign_key: :unified_with_id
    has_many :investments_unified_to_me, class_name: 'Budget::Investment', foreign_key: :unified_with_id

    #GET-98
    def has_unifications?
      investments_unified_to_me.any?
    end

    def is_unified?
      !unified_with_id.blank?
    end
    
    def name_and_group
      "#{title} || #{group.name} - #{heading.name}"
    end

    def image_attached?
      !"application/pdf".eql?(attachment.try(:content_type))
    end

    def likes
      cached_votes_up
    end

    def dislikes
      votes_for.where(vote_flag: false).count
    end

    def total_votes
      votes_for.count
    end

    def votable_by?(user)
      return false unless user
      user.level_three_verified?
      #!user.voted_for?(self) #REV
    end

    def register_selection(user, vote_value)
      vote_by(voter: user, vote: vote_value) if selectable_by?(user)
    end

    def reason_for_not_being_selectable_by(user)
      return permission_problem(user) if permission_problem?(user)
      return :different_heading_assigned unless valid_heading?(user)

      return :no_selecting_allowed unless budget.accepting?
    end

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

    def group_name
      group.name
    end

    def author_name
    author.name
    end

    def author_email
      author.email
    end

    def author_phone
      author.phone_number
    end

    def self.to_csv
      attributes = %w{id title created_at group_name author_name author_email author_phone}

      CSV.generate(headers: true) do |csv|
        csv << attributes.map { |attr| Budget::Investment.human_attribute_name attr }

        all.each do |user|
          csv << attributes.map{ |attr| user.send(attr) }
        end
      end
    end
  end
end
