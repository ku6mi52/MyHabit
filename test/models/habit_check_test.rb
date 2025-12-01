require "test_helper"

class HabitCheckTest < ActiveSupport::TestCase
  test "valid habit_check" do
    check = habit_checks(:one)
    assert check.valid?
  end

  test "habit_id must be unique per daily_record" do
    check = HabitCheck.new(
      daily_record: daily_records(:one),
      habit: habit_checks(:one).habit
    )
    assert_not check.valid?
    assert_includes check.errors[:habit_id], "はすでに存在します"
  end

  test "belongs to daily_record" do
    check = habit_checks(:one)
    assert_respond_to check, :daily_record
    assert_instance_of DailyRecord, check.daily_record
  end

  test "belongs to habit" do
    check = habit_checks(:one)
    assert_respond_to check, :habit
    assert_instance_of Habit, check.habit
  end

  test "checked scope returns only done checks" do
    check1 = habit_checks(:one)
    check1.update!(done: true)
    check2 = habit_checks(:two)
    check2.update!(done: false)

    checked = HabitCheck.checked
    assert_includes checked, check1
    assert_not_includes checked, check2
  end

  test "habit_checks_for_dashboard creates daily_record and habit_checks" do
    user = users(:one)
    date = Date.today

    HabitCheck.habit_checks_for_dashboard(user: user, recorded_on: date)

    daily_record = user.daily_records.find_by(recorded_on: date)
    assert_not_nil daily_record
    assert_equal user.habits.count, daily_record.habit_checks.count
  end

  test "habit_checks_for_dashboard updates checks when provided" do
    user = users(:one)
    habit = Habit.create!(user: user, name: "Test Habit")
    date = Date.today

    checks = { habit.id.to_s => { "done" => "1" } }
    HabitCheck.habit_checks_for_dashboard(user: user, recorded_on: date, checks: checks)

    daily_record = user.daily_records.find_by(recorded_on: date)
    habit_check = daily_record.habit_checks.find_by(habit: habit)
    assert habit_check.done
  end

  test "tasks_completion_rate calculates rate correctly" do
    user = users(:one)
    daily_record = daily_records(:one)
    habit = habits(:one)

    habit_check = daily_record.habit_checks.find_or_create_by!(habit: habit)
    habit_check.update!(done: true)

    rates = HabitCheck.tasks_completion_rate([daily_record])
    assert_equal 100, rates[daily_record.id]
  end

  test "calculate_completion_rate works" do
    daily_record = daily_records(:one)
    habit = habits(:one)

    habit_check = daily_record.habit_checks.find_or_create_by!(habit: habit)
    habit_check.update!(done: true)

    rate = HabitCheck.calculate_completion_rate(daily_record)
    assert_equal 100, rate
  end
end
