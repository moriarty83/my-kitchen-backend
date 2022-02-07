class UsersController < ApplicationController
    before_action :authorized, only: [:auto_login, :update, :delete_request, :delete]



    #REGISTER
    def create
        puts "Data"
        puts params[:formData][:email]
        puts "End data"
        puts user_params
        @user = User.create(user_params)
        puts "ID"
        puts @user.id
        if @user.valid?
            populate_starters
            exp = Time.now.to_i + 4 * 3600
            puts "exp: #{exp}"
            token = encode_token({user_id: @user.id, exp: exp})
            UserMailer.with(user: @user).welcome_email.deliver_later
            render json: {user: @user, token: token, exp: exp}
        else
            render json: @user.errors, status: :unprocessable_entity
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
        newIcon = update_user_params["icon"]
        user.update(nickname: newNickname, icon: newIcon)
        
        if user.save
            user = User.find(@user.id)
            exp = Time.now.to_i + 4 * 3600
            puts "exp: #{exp}"
            token = encode_token({user_id: @user.id, exp: exp})
            puts @user.nickname

            render json: {user: user, token: token, exp: exp}
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

    def forgot
        if params[:email].blank? # check if email is present
            return render json: {error: 'Email not present'}
        end

        @user = User.find_by(email: params[:email]) # if present find user by email
        puts @user
        if @user.present?
            generate_password_token(@user) #generate pass token
            UserMailer.with(user: @user).reset_password_email.deliver_later
            render json: {status: 'ok'}, status: :ok
        else
            render json: {error: ['Email address not found. Please check and try again.']}, status: :not_found
        end
    end
    
    def reset
        token = params[:token].to_s

        if params[:token].blank?
            return render json: {error: 'Token not present'}
        end

        user = User.find_by(reset_password_token: token)

        if user.present? && password_token_valid?
            if user.reset_password!(params[:password])
            render json: {status: 'ok'}, status: :ok
            else
            render json: {error: user.errors.full_messages}, status: :unprocessable_entity
            end
        else
            render json: {error:  ['Link not valid or expired. Try generating a new link.']}, status: :not_found
        end
    end


  private

    def user_params 

        params.permit(:email, :password, :nickname, :icon)
        @user_params = {email: params[:formData][:email], password: params[:formData][:password], nickname: params[:formData][:nickname], icon: params[:formData][:icon]}
    end

    def update_user_params
        params.require(:user).permit(:nickname, :icon)
    end

    def delete_user_params
        params.require(:user).permit(:email)
    end

    def populate_starters
        puts "USER"
        puts @user.id
        if params[:starterIngredients].length() > 0
            for item in params[:starterIngredients] do
                user_ing = UserIngredient.new(user_id: @user.id, ingredient_id: item[:ingredient_id])
                user_ing.save
            end
        end
    end

    def generate_password_token(user)
        user.reset_password_token = generate_token
        user.reset_password_sent_at = Time.now.utc
        user.save
       end
       
       def password_token_valid?
        (user.reset_password_sent_at + 4.hours) > Time.now.utc
       end
       
       def reset_password!(password)
        user.reset_password_token = nil
        user.password = password
        save!
    end

    def generate_token
        SecureRandom.hex(10)
    end


end
