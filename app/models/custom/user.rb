require_dependency Rails.root.join('app', 'models', 'user').to_s

class User

  has_many :meetings

  before_validation :normalize_email

  def downgrade_verification_level
    update_column(:verified_at, nil)
    update_column(:residence_verified_at, nil)
    update_column(:census_removed_at, Time.current)
  end

  def normalize_email
    return unless self.email
    if self.email.include?('+') && self.email.include?('@')
      name, domain = self.email.split('@')
      valid_part, _ = name.split('+')
      self.email = "#{valid_part}@#{domain}"
    end
  end


  def to_param
    username
  end

  def self.find_by_param(input)
    find_by_username(input)
  end
end
