require 'test_helper'

class UserMailerTest < ActionMailer::TestCase
  test "account activation" do
    user = users(:alfonso)
    user.activation_token = User.new_token
    mail = UserMailer.account_activation(user)
    assert_equal "account activation lmao", mail.subject
    assert_equal [user.email], mail.to
    assert_equal ["supinchemadre@ahuev.o"], mail.from
    assert_match user.name,                  mail.body.encoded
    assert_match user.activation_token,      mail.body.encoded
    assert_match CGI.escape(user.email),     mail.body.encoded
  end
end
