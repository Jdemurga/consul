require_dependency Rails.root.join('app', 'models', 'site_customization', 'page').to_s

class SiteCustomization::Page

  MAX_POSITIONS_IN_COVER = 24

  validates :cover_position, uniqueness: true, numericality: { greater_than_or_equal_to: 1, less_than_or_equal_to: MAX_POSITIONS_IN_COVER, only_integer: true }, if: :show_in_cover_flag

  scope :order_by_position, -> { order('cover_position asc')}
  scope :with_show_in_cover_flag, -> { where(status: 'published', show_in_cover_flag: true).order('cover_position ASC') }

  def url
    "/#{slug}"
  end
end
