require 'test_helper'

class MicropostTest < ActiveSupport::TestCase
  
  def setup
  	@user = users(:alfonso)
  	@micropost = @user.microposts.build(content: "voglio combatterti")
  end

  test "should be valid" do
  	assert @micropost.valid?
  end

  test "user id should be present" do
  	@micropost.user_id = nil
  	assert_not @micropost.valid?
  end

  test "content should be present" do
  	@micropost.content = nil
  	assert_not @micropost.valid?
  end

  test "content should be <= 140 char" do
  	@micropost.content = "q" * 141
  	assert_not @micropost.valid?
  end

  test "order should be most recent first" do
  	assert_equal microposts(:most_recent), Micropost.first
  end
end
