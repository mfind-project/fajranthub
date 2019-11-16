# frozen_string_literal: true

class ChbCardClickedResponse < ChbBase
  def call
    card_clicked_response
  end

  private

  def card_clicked_response
    @fajrant.update_attributes(ends_at: Time.zone.now) if finish?
    ChbResponseFormatter.new(response_formatter_attributes).call
  end

  def response_formatter_attributes
    {}.tap do |hash|
      hash[:widget_text] = text
      hash[:buttons] = buttons if inc?
    end
  end

  def text
    return "<b>#{@body[:user][:displayName]}</b> zakończona przerwa" if finish?

    'Za ile wracasz?' if inc?
  end

  def finish?
    @body[:action][:actionMethodName] == 'finish'
  end

  def inc?
    @inc ||= @body[:action][:actionMethodName] == 'inc'
  end

  def buttons
    [1, 2, 3].map do |n|
      { text: "#{n}0min", action_method_name: 'brb', parameters: { key: 'amount', value: "#{n}0min" } }
    end
  end
end
