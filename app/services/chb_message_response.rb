# frozen_string_literal: true

class ChbMessageResponse < ChbBase
  def call
    message_response
  end

  private

  def message_response
    if (@body[:message][:argumentText])
      return { text: 'Nie rozpoznaje polecenia' } if minutes.nil?
      @fajrant.present? ? @fajrant.update_attributes(attributes) : Fajrant.create!(attributes)
      text = "<b>#{@body[:user][:displayName]}</b> zapisano <font color=\"#ff0000\">#{minutes}</font> przerwy"
      ChbResponseFormatter.new(widget_text: text).call
    else
      text = 'Co chcesz zrobić?'
      buttons = [
        { text: 'Przedłuż', action_method_name: 'inc', parameters: { key: 'amount', value: '10min' } },
        { text: 'Zakończ', action_method_name: 'finish', parameters: {} }
      ]
      ChbResponseFormatter.new(widget_text: text, buttons: buttons).call
    end
  end

  def minutes
    @minutes ||= @body[:message][:argumentText].scan(/\d+/).first
  end

  def attributes
    @attributes ||= {}.tap do |hash|
      hash[:ends_at] = now + minutes.to_i * 60
      hash[:started_at] = now if @fajrant.blank? || @fajrant.ends_at < now
      hash[:user_id] = User.find_by(email: @body[:message][:sender][:email]).id
    end
  end

  def now
    @now ||= Time.zone.now
  end
end
