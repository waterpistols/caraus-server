class Api::V1::UsersController < ApplicationController
  respond_to :json
  before_action :authenticate_with_token!, only: [:update, :destroy]
  def show
    user = User.find(params[:id])

    if user
      render json: user, status: 200, location: [:api, user], root: false
    else
      render json: { errors: user.errors }, status: 404
    end
  end

  def create
    # render json: user_params, status: 201, location: [:api, user], root: false
    user = User.new(user_params)

    if user.save
      render json: user, status: 201, location: [:api, user], root: false
    else
      render json: { errors: user.errors }, status: 422
    end
  end

  def update
    user = User.find(params[:id])
    
    if user.update(user_params)
      render json: user, status: 200, location: [:api, user]
    else
      render json: { errors: user.errors }, status: 422
    end
  end

  def destroy
    user = User.find(params[:id])
    user.destroy
    head 204
  end

  private
    def user_params
      params.permit(:email, :password, :password_confirmation)
    end
end
