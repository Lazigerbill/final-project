class OauthsController < ApplicationController
	skip_before_filter :require_login
	def oauth
		login_at(auth_params[:provider])
	end

	def callback
		provider = auth_params[:provider]
		if @user = login_from(provider)
			redirect_to user_path(@user), :notice => "Logged in successfully from #{provider.titleize}!"
		else
			begin
				@user = create_from(provider)
        # NOTE: this is the place to add '@user.activate!' if you are using user_activation submodule
        @log = Log.new(
        	user_id: @user.id,
        	points: 100000,
        	asset_points: 100000,
        	transactions: "New account",
        	investor_type: "New account",
            basket_empty: true
        )
        @log.save
        reset_session # protect from session fixation attack
        auto_login(@user)
        redirect_to user_path(@user), :notice => "Logged in from #{provider.titleize}! New account created!"
    rescue
    	redirect_to root_path, :alert => "Failed to login from #{provider.titleize}!"
    end
end
end
private
def auth_params
	params.permit(:code, :provider, :user_id, :uid, :oauth_token, :oauth_verifier)
end
end
