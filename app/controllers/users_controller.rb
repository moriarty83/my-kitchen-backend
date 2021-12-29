class UsersController < ApplicationController
    before_action :authorized, only: [:auto_login, :update, :delete_request, :delete]



    #REGISTER
    def create
        puts user_params
        @user = User.create(user_params)
        if @user.valid?
            exp = Time.now.to_i + 4 * 3600
            puts "exp: #{exp}"
            token = encode_token({user_id: @user.id, exp: exp})
            UserMailer.with(user: @user).welcome_email.deliver_later
            render json: {user: @user, token: token, exp: exp}
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
            puts "exp: #{exp}"
            token = encode_token({user_id: @user.id, exp: exp})
            render json: {user: @user, token: token, exp: exp}
        else
            "Bad user"
            render json: @user.errors, status: :unprocessable_entity
        end
    end

    def auto_login
        render json: @user
    end


    # PATCH/PUT 
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

    def delete
        user = User.find(@user.id)
        puts "delete timestamp: #{user.delete_timestamp}"
        puts !!user.delete_timestamp
        # See if user is eligible for delete.
        if (!!user.delete_timestamp && user.delete_timestamp + 60*30 > Time.now.to_i)
            puts "I can delete you!"
            user = User.find(@user.id)
            if user.ingredients.destroy_all
                if
                    user.recipes.destroy_all
                    if (user.destroy)
                        render json: user, status: :accepted, location: user
                    else
    
                    render json: user.errors, status: :unprocessable_entity
                    end
                else
                    render json: user.errors, status: :unprocessable_entity
                end
            else
    
            render json: user.errors, status: :unprocessable_entity
            end
        else
    
        render json: user.errors, status: :unprocessable_entity
        end
    end

    def delete_request
        user = User.find(@user.id)
        now = Time.now.to_i
        user.update(delete_timestamp: now)
        puts "now: #{now.class}"
        if user.save
            puts "Timestamp: #{user.delete_timestamp}"
            UserMailer.with(user: @user).delete_request_email.deliver_later

            render json: user, status: :accepted, location: user
          else
    
            render json: user.errors, status: :unprocessable_entity
          end
    end

  private

    def user_params
        params.permit(:email, :password, :nickname)
    end

    def update_user_params
        params.require(:user).permit(:nickname)
    end

    def delete_user_params
        params.require(:user).permit(:email)
    end


end
