# frozen_string_literal: true

class FajrantsController < ApplicationController
  def index
    render json: Fajrant.all
  end

  def show
    render json: fajrant
  end

  def create
    fp = fajrant_params
    fp[:ends_at] = Time.now + params[:end_interval].to_i * 60
    if Fajrant.exists?(user_id: params[:user_id])
      fajrant.update_attributes(fp.except(:end_interval))
    else
      @fajrant = Fajrant.create!(fp.except(:end_interval))
    end

    render json: fajrant, status: 201
  end

  def destroy
    fajrant.destroy!
  end

  private

  def fajrant_params
    params.permit(:user_id, :end_interval, :description).merge(started_at: DateTime.now)
  end

  def fajrant
    @fajrant ||= Fajrant.find_by(user_id: params[:user_id])
  end
end
