class ChbController < ApplicationController
  include DateParser

  def create
    request_body = JSON.parse(request.body.string).with_indifferent_access
    case request_body[:type]
    when 'ADDED_TO_SPACE'
      @response = { text: "Dzięki za dodanie do pokoju." }
    when 'MESSAGE'
      @response = message_response(request_body)
    when 'CARD_CLICKED'
      @response = card_clicked_response(request_body)
    end

    render json: @response
  end

  private

  def message_response(body)
    if body[:message][:argumentText]
      minutes = body[:message][:argumentText].scan(/\d+/).first
      return { text: 'Nie rozpoznaje polecenia' } if minutes.nil?

      user = UserMatcher.new(email: body[:user][:email], name: body[:user][:displayName], google_user_id: body[:user][:name]).call
      @fajrant = FajrantHandler.new(user: user, end_interval: minutes).call
      text = "<b>#{body[:user][:displayName]}</b> zapisano <font color=\"#ff0000\">#{minutes} minut</font> przerwy"
      ChbResponseFormatter.new(widget_text: text).call
    else
      text = 'Co chcesz zrobić?'
      buttons = [
        { text: 'Rozpocznij/Przedłuż', action_method_name: 'inc', parameters: { key: 'amount', value: '10min' }},
        { text: 'Zakończ', action_method_name: 'finish', parameters: {}}
      ]
      ChbResponseFormatter.new(widget_text: text, buttons: buttons).call
    end
  end

  def card_clicked_response(body)
    case body[:action][:actionMethodName]
    when 'brb'
      minutes = body[:action][:parameters].first[:value].scan(/\d+/).first
      user = UserMatcher.new(email: body[:user][:email], name: body[:user][:displayName], google_user_id: body[:user][:name]).call
      @fajrant = FajrantHandler.new(user: user, end_interval: minutes).call
      text = "<b>#{body[:user][:displayName]}</b> zarejestrowałem <b>#{minutes} minut</b> przerwy, do<b>#{formatted_end_date(@fajrant.ends_at)}</b>"
      ChbResponseFormatter.new(widget_text: text).call
    when 'finish'
      user = UserMatcher.new(email: body[:user][:email], name: body[:user][:displayName], google_user_id: body[:user][:name]).call
      FajrantHandler.new(user: user).call
      # usuwamy przerwe z bazy
      text = "<b>#{body[:user][:displayName]}</b> zakończona przerwa"
      ChbResponseFormatter.new(widget_text: text).call
    when 'inc'
      text = 'Za ile wracasz?'
      buttons = [
        { text: '10min', action_method_name: 'brb', parameters: { key: 'amount', value: '10min' } },
        { text: '20min', action_method_name: 'brb', parameters: { key: 'amount', value: '20min' } },
        { text: '30min', action_method_name: 'brb', parameters: { key: 'amount', value: '30min' } }
      ]
      ChbResponseFormatter.new(widget_text: text, buttons: buttons).call
    else
      text = "<b>#{body[:user][:displayName]}</b> wygląda na to, że nie zgłosiłeś/aś dotychczas przerwy. "\
             "Jeśli zgłosić, wybierz jedną z poniższych opcji:"
      buttons = [
        { text: '10min', action_method_name: 'brb', parameters: { key: 'amount', value: '10min' }},
        { text: '20min', action_method_name: 'brb', parameters: { key: 'amount', value: '20min' }},
        { text: '30min', action_method_name: 'brb', parameters: { key: 'amount', value: '30min' }}
      ]
      ChbResponseFormatter.new(widget_text: text, buttons: buttons).call
    end
  end
end
