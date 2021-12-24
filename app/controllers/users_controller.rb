class UsersController < ApplicationController
    before_action :authorized, only: [:auto_login, :update]



    #REGISTERf
    def create
        puts user_params
        @user = User.create(user_params)
        if @user.valid?
            exp = Time.now.to_i + 4 * 3600
            token = encode_token({user_id: @user.id, exp: exp})
            UserMailer.with(user: @user).welcome_email.deliver_later
            render json: {user: @user, token: token}
        else
            render json: {error: "Invalid username or password"}
        end
    end

    #LOGGING IN 
    def login
        @user = User.find_by(email: params[:email])

        if @user && @user.authenticate(params[:password])
            puts ("Good user")
            exp = Time.now.to_i + 4 * 3600
            token = encode_token({user_id: @user.id})
            render json: {user: @user, token: token}
        else
            render json: {error: "Invalid username or password"}
        end
    end

    def auto_login
        render json: @user
    end


    # PATCH/PUT /ingredients/1
    def update
        puts "updating"
        user = User.find(@user.id)
        newNickname = update_user_params["nickname"]
        user.update(nickname: newNickname)
        
        if user.save
            puts "I'm updated!"
            render json: user
        else
            render json: "no updat"
        end
    end

  private

    def user_params
        params.permit(:email, :password, :nickname)
    end

    def update_user_params
        params.require(:user).permit(:nickname)
    end

end
