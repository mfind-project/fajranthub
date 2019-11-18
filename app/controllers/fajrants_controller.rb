# frozen_string_literal: true

class FajrantsController < ApplicationController
  def index
    render json: Fajrant.all
  end

  def show
    render json: fajrant
  end

  def create
    @user = User.find(params[:user_id])
    render json: FajrantHandler.new(user: @user, end_interval: params[:end_interval], description: params[:description]).call, status: 200
  end

  def destroy
    @user = User.find(params[:user_id])
    render json: FajrantHandler.new(user: @user, end_interval: params[:end_interval], description: params[:description]).call, status: 200
  end

  private

  def fajrant_params
    params.permit(:user_id, :end_interval, :description).merge(started_at: DateTime.now)
  end

  def fajrant
    @fajrant ||= Fajrant.find_by(user_id: params[:user_id])
  end
end
