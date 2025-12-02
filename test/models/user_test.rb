require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "valid user" do
    user = users(:one)
    assert user.valid?
  end

  test "start_weight validation on onboarding_step1" do
    user = User.new(email: "test@example.com", password: "password123")
    user.goal_weight = 65.0
    assert user.valid?(:onboarding_step1) == false
    assert_includes user.errors[:start_weight], "を入力してください"

    user.start_weight = 70.0
    assert user.valid?(:onboarding_step1)
  end

  test "goal_weight validation on onboarding_step2" do
    user = User.new(email: "test@example.com", password: "password123")
    user.start_weight = 70.0
    assert user.valid?(:onboarding_step2) == false
    assert_includes user.errors[:goal_weight], "を入力してください"

    user.goal_weight = 65.0
    assert user.valid?(:onboarding_step2)
  end

  test "onboarding_missing_step returns correct step" do
    user = User.new(email: "test@example.com", password: "password123")
    assert_equal :step1, user.onboarding_missing_step

    user.start_weight = 70.0
    assert_equal :step2, user.onboarding_missing_step

    user.goal_weight = 65.0
    assert_nil user.onboarding_missing_step
  end

  test "daily_record_on returns correct record" do
    user = users(:one)
    date = daily_records(:one).recorded_on
    record = user.daily_record_on(date)
    assert_equal daily_records(:one), record
  end

  test "goal_weight_diff_on calculates difference correctly" do
    user = users(:one)
    daily_record = daily_records(:one)
    diff = user.goal_weight_diff_on(daily_record.recorded_on)
    assert_equal user.goal_weight - daily_record.weight, diff
  end

  test "has many daily_records" do
    user = users(:one)
    assert_respond_to user, :daily_records
  end

  test "has many habits" do
    user = users(:one)
    assert_respond_to user, :habits
  end
end
