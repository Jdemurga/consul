require_dependency Rails.root.join('app', 'models', 'user').to_s

class User
  def to_param
    username
  end

  def self.find_by_param(input)
    find_by_username(input)
  end
end