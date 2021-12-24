# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview
    def welcome_email
        @user = User.last
        UserMailer.with(User.last).welcome_email()
    end
end
