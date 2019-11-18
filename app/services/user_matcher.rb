class UserMatcher
  def initialize(id: nil, email: nil, name: nil, google_user_id: nil)
    @id = id
    @email = email
    @name = name
    @google_user_id = google_user_id
  end

  def call
    match_user
  end

  private

  def match_user
    if user_by_id || user_by_email || user_by_name || user_by_google_user_id
      update_user
    else
      @user = User.create(email: @email, name: @name, google_user_id: @google_user_id)
    end
    @user
  end

  def user_by_id
    @user = User.find_by(id: @id)
    @user.nil? ? false : @user
  end

  def user_by_email
    @user = User.find_by(email: @email)
    @user.nil? ? false : @user
  end

  def user_by_name
    @user = User.find_by(name: @name)
    @user.nil? ? false : @user
  end

  def user_by_google_user_id
    @user = User.find_by(google_user_id: @google_user_id)
    @user.nil? ? false : @user
  end

  def update_user
    new_attributes = {}.tap do |hash|
      hash[:email] = @email if @email
      hash[:name] = @name if @name
      hash[:google_user_id] = @google_user_id if @google_user_id
    end
    return if new_attributes.empty?

    @user.update_attributes(new_attributes)
  end
end
