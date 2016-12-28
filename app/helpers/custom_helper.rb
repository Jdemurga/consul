module CustomHelper

  def format_price(number)
    number_to_currency(number, precision: 0, locale: I18n.default_locale)
  end

  def commissions_as_options(current=nil)

    # TODO - Improve this implementation (did it as workaround because time restricitions)
    options_from_collection_for_select(Commission.order('name'), 'id', 'name', current)
  end
end
