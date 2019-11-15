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
    fp[:ends_at] = Time.now + params[:ends_at].to_i * 60
    if Fajrant.exists?(user_id: params[:user_id])
      fajrant.update_attributes(fp)
    else
      @fajrant = Fajrant.create!(fp)
    end

    render json: fajrant, status: 201
  end

  def destroy
    fajrant.destroy!
  end

  private

  def fajrant_params
    params.permit(:user_id, :ends_at, :description).merge(started_at: DateTime.now)
  end

  def fajrant
    @fajrant ||= Fajrant.find_by(user_id: params[:user_id])
  end
end
