# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include ErrorsHandler

  skip_before_action :verify_authenticity_token
end
