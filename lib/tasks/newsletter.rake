namespace :newsletter do

  desc 'Renders and sends newsletter to users who checked preference "newsletter"'


  task :email, [:subject, :template_name, :image_file_path] => [:environment] do |t, args|

    subject = args[:subject]
    template_name = args[:template_name]
    image_file_path = args[:image_file_path]
    User.newsletter.find_each do |user|

      Mailer.email_newsletter(user, user.email, subject, template_name, image_file_path).deliver_later
      raise "STOP"
    end
  end

end
