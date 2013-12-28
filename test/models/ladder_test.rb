require 'test_helper'

class LadderTest < ActiveSupport::TestCase

  test "ladder has valid name" do
    ladder = Ladder.new(name: "Great ladder")
    assert ladder.valid?, "Ladder name is valid"
  end

  test "Ladder has invalid name" do
    ladder = Ladder.new(name: "Great ladder; mysql()")
    assert !ladder.valid?
  end
end
