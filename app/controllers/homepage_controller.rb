class HomepageController < ApplicationController
  def index
    if cookies[:user]
      @user = User.find_by!(id: cookies[:user])
      redirect_to controller: "users", action: "show", id: @user.id
    end
  end
end
