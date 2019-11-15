# frozen_string_literal: true

class UsersController < ApplicationController
  def index
    respond_to do |format|
      format.json { render json: User.all }
    end
  end

  def show
    respond_to do |format|
      format.json { render json: user }
    end
  end

  def create
    user = User.create!(user_params)
    respond_to do |format|
      format.json { render json: user, status: 201 }
    end
  end

  def destroy
    user.destroy!
  end

  private

  def user
    @user ||= User.find(params[:id])
  end

  def user_params
    params.permit(:google_user_id, :name, :pn_user_id)
  end
end
