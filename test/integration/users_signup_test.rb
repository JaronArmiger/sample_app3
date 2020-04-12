require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  
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
  	follow_redirect!
  	assert_template 'users/show'
  	assert_not flash.empty?
  end
end
