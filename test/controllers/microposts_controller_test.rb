require 'test_helper'

class MicropostsControllerTest < ActionDispatch::IntegrationTest
  
  def setup
  	@micropost = microposts(:festeggiare)
  end

  test "should redirect create when not logged in" do
  	assert_no_difference 'Micropost.count' do
  		post microposts_path params: { micropost: { content: "Dove sta Livia Adami?" } }
  	end
  	assert_redirected_to login_url
  end

  test "should redirect destroy when not logged in" do
  	assert_no_difference 'Micropost.count' do
  		delete micropost_path(@micropost)
    end
    assert_redirected_to login_url
  end

  test "should redirect destroy if micropost doesn't belong to me" do
    log_in_as(users(:alfonso))
    micropost = microposts(:le_centre)
    assert_no_difference 'Micropost.count' do
      delete micropost_path(micropost)
    end
    assert_redirected_to root_url
  end
end
