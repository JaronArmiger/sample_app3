class ApplicationController < ActionController::Base
	include SessionsHelper

	private

		# Confirms a user is logged in
	def logged_in_user
      unless logged_in?
        store_location # puts :forwarding_url in session hash
        flash[:danger] = "you gotta be logged to do that bruh"
        redirect_to login_url
      end
    end
end
