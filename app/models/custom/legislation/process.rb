require_dependency Rails.root.join('app', 'models', 'legislation', 'process').to_s

class Legislation::Process < ActiveRecord::Base
  include Attachable
end