require 'test_helper'

class FeedTest < ActionDispatch::IntegrationTest
  
  def setup
  	@user = users(:alfonso)
  	log_in_as @user
  end

  test "feed appears on home page" do
  	get root_path
  	assert_template 'static_pages/home'
  	feed_items = @user.feed.paginate(page: 1)
  	feed_items.each do |post|
  		assert_match CGI.escapeHTML(post.content), response.body
  	end
  end
end
