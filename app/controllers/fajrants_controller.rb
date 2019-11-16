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
    fp = fajrant_params
    fp[:ends_at] = Time.now + params[:end_interval].to_i * 60
    if Fajrant.exists?(user_id: params[:user_id])
      fajrant.update_attributes(fp.except(:end_interval))
      RestClient.post Rails.application.config.room_url, increment_message, {content_type: :json, accept: :json}
    else
      @fajrant = Fajrant.create!(fp.except(:end_interval))
      RestClient.post Rails.application.config.room_url, create_message, {content_type: :json, accept: :json}
    end

    render json: fajrant, status: 201
  end

  def destroy
    fajrant.destroy!
    RestClient.post Rails.application.config.room_url, finish_message, {content_type: :json, accept: :json}
    render json: {}, status: 200
  end

  private

  def fajrant_params
    params.permit(:user_id, :end_interval, :description).merge(started_at: DateTime.now)
  end

  def fajrant
    @fajrant ||= Fajrant.find_by(user_id: params[:user_id])
  end

  def increment_message
    {'text' => "<#{@user[:google_user_id]}> przedłużył/a przerwę o *#{params[:end_interval]}*"}.to_json
  end

  def create_message
    {'text' => "<#{@user[:google_user_id]}> zarejestrowane *#{params[:end_interval]}* przerwy"}.to_json
  end

  def finish_message
    {'text' => "<#{@user[:google_user_id]}> zakończył/a przerwę"}.to_json
  end
end
