class RegistrationController < ApplicationController
  def create
    user = User.new(user_params)
    if user.save
      # Handle successful save
      render json: { status: 'SUCCESS', message: 'User created successfully', data: user }, status: :created
    else
      # Handle failure, log or render the errors
      render json: { status: 'ERROR', message: 'User not created', errors: user.errors.full_messages }, status: :bad_request
    end
  end

  private
    def user_params
      params.require(:user).permit(:first_name, :last_name, :email, :password, :phone, :password_confirmation)
    end
end


