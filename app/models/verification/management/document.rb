class Verification::Management::Document
  include ActiveModel::Model
  include ActiveModel::Dates

  attr_accessor :document_type
  attr_accessor :document_number

  validates :document_type, :document_number, presence: true

  delegate :username, :email, to: :user, allow_nil: true

  def user
    @user = User.active.by_document(document_type, document_number).first
  end

  def user?
    user.present?
  end

  def in_census?
    response = CensusApiCustom.new.call(document_type, document_number) #GET-57
    response.valid? && valid_age?(response)
  end

  def valid_age?(response)
    if under_age?(response)
      errors.add(:age, true)
      return false
    else
      return true
    end
  end

  def under_age?(response)
    User.minimum_required_age.years.ago.beginning_of_day < response.date_of_birth.beginning_of_day
  end

  def verified?
    user? && user.level_three_verified?
  end

  def verify
    user.update(verified_at: Time.current) if user?
  end

end
