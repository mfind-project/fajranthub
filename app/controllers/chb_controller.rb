class ChbController < ApplicationController
  def create
    @response = case request_body[:type]
                when 'ADDED_TO_SPACE'
                  ChbAddedToSpaceResponse.new.call
                when 'MESSAGE'
                  ChbMessageResponse.new(request_body: request_body, fajrant: fajrant).call
                when 'CARD_CLICKED'
                  ChbCardClickedResponse.new(request_body: request_body, fajrant: fajrant).call
                end

    render json: @response
  end

  private

  def request_body
    @request_body ||= JSON.parse(request.body.string).with_indifferent_access
  end

  def fajrant
    Fajrant.find_by(user: User.find_by(email: request_body[:message][:sender][:email]))
  end
end
