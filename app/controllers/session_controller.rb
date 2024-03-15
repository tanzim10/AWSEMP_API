class SessionController < ApplicationController
	def create
		user = User.find_by(email: params[:email])
	  
		if user && user.authenticate(params[:password])
		  session[:user_id] = user.id
		  token = generate_token  
	  
		  render json: { 
				   message: 'Login successful', 
				   user: user, 
				   token: token 
				 }, status: :ok 
		else
		  render json: { error: 'Invalid email or password' }, status: :unauthorized
		end
	end

	def destroy
		session.delete(:user_id)
		head :no_content
	end

	private
		def generate_token
		chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890".chars # Convert to array
		Array.new(32) { chars.sample }.join
	  end
	  
end

		
		
		

