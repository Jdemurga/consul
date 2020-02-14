class DeviseMailer < Devise::Mailer
  before_action :add_inline_attachment!
  helper :application, :settings
  include Devise::Controllers::UrlHelpers
  default template_path: 'devise/mailer'

  protected

  def devise_mail(record, action, opts={})
    I18n.with_locale record.locale do
      super(record, action, opts)
    end
  end

  private

  def add_inline_attachment!
    attachments.inline["logo_email.png"] = File.read(Rails.root.join('app/assets/images/logo_email.png'))
  end
end
