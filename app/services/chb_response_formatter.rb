class ChbResponseFormatter
  def initialize(widget_text:, buttons: [])
    @widget_text = widget_text
    @buttons = buttons
  end

  def call
    generate_response
  end

  private

  def generate_response
    {
      cards: [{
        sections: [
          widgets: [generate_widgtes, generate_buttons].compact
        ]
      }]
    }
  end

  def generate_widgtes
    {
      textParagraph:
      {
        text: @widget_text
      }
    }
  end

  def generate_buttons
    return if @buttons.empty?

    {
      buttons: @buttons.map do |button|
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
    }
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
