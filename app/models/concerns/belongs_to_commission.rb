module BelongsToCommission
  extend ActiveSupport::Concern

  included do
    belongs_to :commission
    validate :validate_commission_can_not_be_updated_twice
  end


  def validate_commission_can_not_be_updated_twice
    errors.add(:commission, I18n.t('errors.commission_can_not_be_updated_twice')) unless commission_id_was.nil?
  end

  class_methods do
  end

end