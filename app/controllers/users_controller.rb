# frozen_string_literal: true

class UsersController < ApplicationController
  def index
    render json: user
  end

  def create
    if User.exists?(email: params[:email])
      render json: user, status: 200
    else
      user = User.create!(user_params)
      render json: user, status: 201
    end
  end

  def destroy
    user.destroy!
  end

  private

  def user
    @user ||= User.find_by!(email: params[:email])
  end

  def user_params
    params.permit(:email, :google_user_id)
  end
end
