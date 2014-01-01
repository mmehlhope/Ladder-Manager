require 'test_helper'

class LadderTest < ActiveSupport::TestCase
  test "ladder has valid name" do
    ladder = Ladder.new({:name => "test", :admin_email => "test@test.com", :password => "test", :password_confirmation =>"test"})
    assert ladder.valid?, "Ladder name is valid"
  end

  test "Ladder has invalid name" do
    ladder = Ladder.new({:name => "Great ladder; mysql()", :admin_email => "test@test.com", :password => "test", :password_confirmation =>"test"})
    assert !ladder.valid?, "Ladder name is not invalid"
  end
end
