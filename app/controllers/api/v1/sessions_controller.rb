require 'aws-sdk'

class Api::V1::SessionsController < ApplicationController
  before_action :authenticate_with_token!, :except => [:signup, :create, :reset_password]
  respond_to :json

  def signup
    user = User.new(user_params)
    
    if user.save
      sign_in user
      token = UserAuthenticationToken.new
      user.user_authentication_tokens << token
      user.auth_token = token.token          

      response = ActiveSupport::JSON.decode(user.to_json)
      response[:auth_token] = token.token

      render json: response, status: 201, location: [:api, user], root: false
    else
      render json: { errors: user.errors }, status: 422
    end
  end

  def create
    user_email    = params[:session][:email]
    user_password = params[:session][:password]

    user = user_email.present? && User.find_by(email: user_email)

    if user.nil?
      render json: { errors: "Invalid email or password" }, status: 422
    elsif user.valid_password? user_password
      sign_in user
      token = UserAuthenticationToken.new
      user.user_authentication_tokens << token
      user.auth_token = token.token
      user.save      

      response = ActiveSupport::JSON.decode(user.to_json)
      response[:auth_token] = token.token

      render json: response, status: 200, root: false
    else
      render json: { errors: "Invalid email or password" }, status: 422
    end
  end

  def reset_password
    user = User.find_by(:email =>  user_params[:email])
    
    if user
      new_password = SecureRandom.hex(4)
      user.password = new_password
      user.save
      PasswordMailer.reset_password(user_params[:email], new_password).deliver
      head 201
    else
      render json: { errors: "Invalid email" }, status: 422
    end
  end

  def destroy
    user_authentication_token = UserAuthenticationToken.find_by(token: params[:id])    
    user_authentication_token.destroy
    head 204
  end

  private
    def user_params
      params.permit(:email, :password, :password_confirmation)#, :first_name, :last_name, :username, :facebook_uid)
    end
end