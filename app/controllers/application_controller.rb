class ApplicationController < ActionController::Base
	def hello
		render html: "sup bitches"
	end
end
