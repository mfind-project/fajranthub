class ChbController < ApplicationController
  respond_to :json

  def create
    case request.body.type
    when 'ADDED_TO_SPACE'
      @response = { text: "Dzięki za dodanie do pokoju." }
    when 'MESSAGE'
      @response = message_response(request.body)
    when 'CARD_CLICKED'

    end

    respond_to do |format|
      # format.html do
      #
      # end
      format.json { render json: @response.to_json }
    end
  end

  private

  def message_response(body)
    if (body.message.argumentText)
      minutes = body.message.argumentText.scan(/\d+/).first
      return { text: 'Nie rozpoznaje polecenia' } if minutes.nil?
      # initialize(widget_text:, buttons: nil)
      text = "<b>#{body.user.displayName}</b> zapisano <font color=\"#ff0000\">#{amount}</font> przerwy"
      ChbResponseFormatter.new(widget_text: text)
    else
      text = 'Co chcesz zrobić?'
      buttons = [
        { text: 'Przedłuż', action_method_name: 'inc', parameters: { key: 'amount', value: '10min' }},
        { text: 'Zakończ', action_method_name: 'finish', parameters: {}},
      ]
      ChbResponseFormatter.new(widget_text: text, buttons: buttons)
    end
  end
end
