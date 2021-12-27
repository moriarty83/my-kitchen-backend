class UserMailer < ApplicationMailer

    default from: 'noreply@mykitchen.com'

    def welcome_email
        @user = params[:user]
        @url = "http://example.com/login"

        mail(to: @user.email,
            subject: 'Welcome to MyKitchen')
        
    end

    def delete_request_email
        @user = params[:user]
        @url = "http://localhost:3001/mykitchen/delete/#{rand(100000..999999)}"

        mail(to: @user.email,
            subject: 'MyKitchen - Account Change Request')
        
    end
end
