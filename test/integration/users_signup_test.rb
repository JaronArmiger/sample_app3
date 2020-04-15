require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  
  def setup
    ActionMailer::Base.deliveries.clear
  end

  test "invalid signup info" do
  	get signup_path
  	assert_no_difference 'User.count' do
  		post users_path, params: { user: { name: "",
  										   email: "user@invalid",
  										   password: "carajo",
  										   password_confirmation: "mierda" } }
  	end
  	assert_template 'users/new'
  	assert_select 'div#error_explanation'
  	assert_select 'div.alert'
  end

  test "valid signup info" do
  	get signup_path
  	assert_difference 'User.count', 1 do
  		post users_path, params: { user: { name: "paquito",
  										                   email: "paco@paco.pa",
  										                   password: "mierda",
  										                   password_confirmation: "mierda" } }
  	end
  	assert_equal 1, ActionMailer::Base.deliveries.size
    # assigns lets me access instance vars in the corresponding action
    # in this case the action was Users#create
    # because @user is defined in Users#create
    # I can access it with assigns(:user)
    user = assigns(:user)
    assert_not user.activated?
    # Try to log in before activation
    log_in_as user
    assert_not is_logged_in?
    # Invalid activation token
    get edit_account_activation_path("invalid token", email: user.email)
    assert_not is_logged_in?
    # Valid token, wrong email
    get edit_account_activation_path(user.activation_token, email: "cazzo")
    assert_not is_logged_in?
    # Valid token and email
    get edit_account_activation_path(user.activation_token, email: user.email)
    assert user.reload.activated?
    follow_redirect!
  	assert_template 'users/show'
  	assert is_logged_in?
  end
end
