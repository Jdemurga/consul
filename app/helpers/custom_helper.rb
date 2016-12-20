module CustomHelper
  def format_price(number)
    number_to_currency(number, precision: 0, locale: I18n.default_locale)
  end
end
