require_dependency Rails.root.join('app', 'models', 'user').to_s

class User

  before_save :normalize_email

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