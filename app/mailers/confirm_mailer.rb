class ConfirmMailer < ApplicationMailer
    default from: "from@example.com"

    def confirm_email(user)
        @user = user
        mail(to: @user.email, subject: 'Confirm your Email')
    end
end
