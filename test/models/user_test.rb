require 'test_helper'

class UserTest < ActiveSupport::TestCase
  
  def setup
  	@user = User.new(name: "alfonso", email: "caro@quintero.mx",
                     password: "chingon", password_confirmation: "chingon")
  end

  test "should be valid" do
  	assert @user.valid?
  end

  test "name should be present" do
  	@user.name = "    "
  	assert_not @user.valid?
  end

  test "email should be present" do
  	@user.email = "    "
  	assert_not @user.valid?
  end

  test "name should not be too long" do
  	@user.name = "a" * 51
  	assert_not @user.valid?
  end

  test "email should not be too long" do
  	@user.email = "a" * 244 + "@example.com"
  	assert_not @user.valid?
  end

  test "email validation should accept valid addresses" do
  	valid_addresses = %w[user@example.com USER@foo.COM 
  						A_US-ER@foo.bar.org first.last@foo.jp
  					    alice+bob@baz.cn]
  	valid_addresses.each do |address|
  		@user.email = address
  		assert @user.valid?, "#{address.inspect} should be valid"
  	end
  end

  test "email validation should reject invalid addresses" do
  	invalid_addresses = %w[user@example,com user_at_foo.org
  						   user.name@example. foo@bar_baz.com
  						   foo@bar..com]
  	invalid_addresses.each do |address|
  		@user.email = address
  		assert_not @user.valid?, "#{address.inspect} should be invalid"
  	end
  end

  test "email addresses should be unique" do
  	duplicate_user = @user.dup
  	@user.save
  	assert_not duplicate_user.valid?
  end

  test "email addresses should be saved as lower-case" do
  	mixed_case_email = "Foo@ExAMPle.Com"
  	@user.email = mixed_case_email
  	@user.save
  	assert_equal mixed_case_email.downcase, @user.reload.email
  end

  test "password should be present (nonblank)" do
    @user.password = @user.password_confirmation = " " * 6
    assert_not @user.valid?
  end

  test "password should have a minimum length" do
    @user.password = @user.password_confirmation = "a" * 5
    assert_not @user.valid?
  end

  test "authenticated? should return false with a nil digest" do
    # @user already has a nil remember_digest
    assert_not @user.authenticated?(:remember, '')
  end

  test "associated microposts should be destroyed" do
    @user.save
    @user.microposts.create!(content: "che cosa fai?")
    assert_difference 'Micropost.count', -1 do
      @user.destroy
    end
  end

  test "should follow and unfollow a user" do
    alfonso = users(:alfonso)
    francoise  = users(:francoise)
    assert_not alfonso.following?(francoise)
    alfonso.follow(francoise)
    assert alfonso.following?(francoise)
    assert francoise.followers.include?(alfonso)
    alfonso.unfollow(francoise)
    assert_not alfonso.following?(francoise)
  end

  test "feed should have the right posts" do
    alfonso   = users(:alfonso)
    ursula    = users(:ursula)
    francoise = users(:francoise)
    # posts from followed user
    ursula.microposts.each do |post_following|
      assert alfonso.feed.include?(post_following)
    end
    # posts from self
    alfonso.microposts.each do |post_self|
      assert alfonso.feed.include?(post_self)
    end
    # posts from unfollowed user
    francoise.microposts.each do |post_unfollowed|
      assert_not alfonso.feed.include?(post_unfollowed)
    end
  end
end







