class ChbResponseFormatter
  def initialize(widget_text:, buttons: nil)
    @widget_text = widget_text
    @buttons = buttons
  end

  def call
    generate_response.to_json
  end

  private

  def generate_response
    {
      cards: [{
        sections: [
          {}.tap do |hash_body|
            hash_body[:widgets] = generate_widgtes
            hash_body[:buttons] = generate_buttons if @buttons.any?
          end
        ]
      }]
    }
  end

  def generate_widgtes
    [
      {
        textParagraph:
        {
          text: @widget_text
          # text: `<b>${req.body.user.displayName}</b> zapisano <font color=\"#ff0000\">${amount}</font> przerwy`
        }
      }
    ]
  end

  def generate_buttons
    @buttons.map do |button|
      {
        textButton:
        {
          text: button[:text],
          onClick:
          {
            action: {}.tap do |on_click|
                      on_click[:actionMethodName] = button[:action_method_name]
                      on_click[:parameters] = generate_button_parametrs(button) if button[:parameters].any?
                    end
            }
          }
        }
    end
  end

  def generate_button_parametrs(button)
    [
      {
        key: button[:parameters][:key],
        value: button[:parameters][:value]
      }
    ]
  end
end
