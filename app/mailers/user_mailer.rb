class UserMailer < ApplicationMailer

    default from: 'noreply@mykitchen.com'

    def welcome_email
        @user = User.last
        @url = "http://example.com/login"

        mail(to: @user.email,
            bcc: moriarty83@gmail.com,
            subject: 'Welcome to MyKitchen')
    end
end
