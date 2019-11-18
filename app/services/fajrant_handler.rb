class FajrantHandler
  include DateParser

  def initialize(user:, end_interval: nil, description: nil)
    @user = user
    @started_at = Time.now if end_interval
    @end_interval = end_interval if end_interval
    @ends_at = count_end_time if end_interval
    @description = description if end_interval
  end

  def call
    RestClient.post(Rails.application.config.room_url, handle_fajrant, { content_type: :json, accept: :json })
    @fajrant
  end

  private

  def count_end_time
    @started_at + @end_interval.to_i * 60
  end

  def handle_fajrant
    if @end_interval.nil?
      fajrant
      @fajrant.destroy!
      finish_message
    elsif Fajrant.exists?(user_id: @user.id)
      fajrant.update_attributes(ends_at: fajrant.ends_at + @end_interval.to_i * 60, description: @description)
      increment_message
    else
      @fajrant = Fajrant.create(user: @user, started_at: @started_at, ends_at: @ends_at, description: @description)
      create_message
    end
  end

  def fajrant
    @fajrant ||= Fajrant.find_by(user_id: @user.id)
  end

  def increment_message
    {'text' => "<#{@user[:google_user_id]}> przedłużył/a przerwę o *#{@end_interval} minut*, do #{formatted_end_date(@fajrant.ends_at)}"}.to_json
  end

  def create_message
    {'text' => "<#{@user[:google_user_id]}> zarejestrowano *#{@end_interval} minut* przerwy, do #{formatted_end_date(@fajrant.ends_at)}"}.to_json
  end


  def finish_message
    {'text' => "<#{@user[:google_user_id]}> zakończył/a przerwę"}.to_json
  end
end
