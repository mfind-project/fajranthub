# frozen_string_literal: true

class UsersController < ApplicationController
  def index
    if cookies[:user]
      @user = User.find_by!(id: cookies[:user])
      redirect_to action: "show", id: @user.id
    end
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

    cookies[:user] = @user.id;
    session[:user_id] = @user.id
    respond_to do |format|
      format.html { redirect_to action: "show", id: @user.id }
      format.json { render json: user, status: 201 }
    end
  end

  def show
    @user = User.find(params[:id])
    @fajrant = Fajrant.find_by(user_id: params[:id])
    @timer = (@fajrant) ? (@fajrant[:ends_at] - Time.now).to_i : 0;
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
