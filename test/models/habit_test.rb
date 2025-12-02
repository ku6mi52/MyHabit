require "test_helper"

class HabitTest < ActiveSupport::TestCase
  test "valid habit" do
    habit = habits(:one)
    assert habit.valid?
  end

  test "name is required" do
    habit = Habit.new(user: users(:one))
    assert_not habit.valid?
    assert_includes habit.errors[:name], "を入力してください"
  end

  test "name cannot be longer than 50 characters" do
    habit = Habit.new(user: users(:one), name: "a" * 51)
    assert_not habit.valid?
    assert_includes habit.errors[:name], "は50文字以内で入力してください"
  end

  test "belongs to user" do
    habit = habits(:one)
    assert_respond_to habit, :user
    assert_instance_of User, habit.user
  end

  test "has many habit_checks" do
    habit = habits(:one)
    assert_respond_to habit, :habit_checks
  end

  test "has many daily_records through habit_checks" do
    habit = habits(:one)
    assert_respond_to habit, :daily_records
  end

  test "recent scope orders by created_at desc" do
    habit1 = Habit.create!(user: users(:one), name: "First")
    habit2 = Habit.create!(user: users(:one), name: "Second")
    recent_habits = Habit.recent
    assert_equal habit2, recent_habits.first
  end
end
