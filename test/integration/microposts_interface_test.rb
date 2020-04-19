require 'test_helper'

class MicropostsInterfaceTest < ActionDispatch::IntegrationTest
  
  def setup
    @user = users(:alfonso)
  end

  test "micropost interface" do
    log_in_as(@user)
    get root_path
    assert_select 'div.pagination'
    # Invalid submission
    assert_no_difference 'Micropost.count' do
      post microposts_path, params: { micropost: { content: " " } }
    end
    assert_select 'div#error_explanation'
    assert_select 'a[href=?]', '/?page=2' # correct pagination link
    # valid submission
    content = "jai voyage aux confins de la galaxie"
    assert_difference 'Micropost.count', 1 do
      post microposts_path, params: { micropost: { content: content } }
    end
    assert_redirected_to root_url
    follow_redirect!
    assert_match content, response.body
    # delete post
    assert_select 'a', text: 'effacer'
    first_micropost = @user.microposts.paginate(page: 1).first
    assert_difference 'Micropost.count', -1 do
      delete micropost_path(first_micropost)
    end
    # visit another user's page (no delete links)
    get user_path(users(:ursula))
    assert_select 'a', text: 'effacer', count: 0
  end

  test "sidebar micropost count" do
    log_in_as @user
    get root_path
    assert_match "#{@user.microposts.count} microposts", response.body
  end
end
