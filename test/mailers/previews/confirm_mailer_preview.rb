# Preview all emails at http://localhost:3000/rails/mailers/confirm_mailer
class ConfirmMailerPreview < ActionMailer::Preview
    def confirm_mail_preview
        ConfirmMailer.confirm_email(User.first)
    end
end
