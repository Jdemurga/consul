class ApplicationMailer < ActionMailer::Base
  before_action :add_inline_attachment!
  helper :settings
  default from: "#{Setting['org_name']} noreply@getafe.es"
  layout 'mailer'

  private

  def add_inline_attachment!
    attachments.inline["logo_email.png"] = File.read(Rails.root.join('app/assets/images/logo_email.png'))
  end
end
