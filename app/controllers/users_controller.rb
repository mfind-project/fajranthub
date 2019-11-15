# frozen_string_literal: true

class UsersController < ApplicationController
  def index
    # render json: user
  end

  def new
    @user = User.new
  end

  def create
    if User.exists?(email: user_params[:email])
      user
    else
      @user = User.create!(user_params)
    end

    session[:user_id] = @user.id
    respond_to do |format|
      format.html { redirect_to action: "show", id: @user.id }
      format.json { render json: user, status: 201 }
    end
  end

  def show
  end

  def destroy
    user.destroy!
  end

  private

  def user
    @user ||= User.find_by!(email: user_params[:email])
  end

  def user_params
    params.require(:user).permit(:email, :google_user_id)
  end
end
