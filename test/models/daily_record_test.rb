require "test_helper"

class DailyRecordTest < ActiveSupport::TestCase
  test "valid daily_record" do
    record = daily_records(:one)
    assert record.valid?
  end

  test "recorded_on is required" do
    record = DailyRecord.new(user: users(:one))
    assert_not record.valid?
    assert_includes record.errors[:recorded_on], "を入力してください"
  end

  test "recorded_on must be unique per user" do
    record = DailyRecord.new(
      user: users(:one),
      recorded_on: daily_records(:one).recorded_on
    )
    assert_not record.valid?
    assert_includes record.errors[:recorded_on], "はすでに存在します"
  end

  test "weight validation" do
    record = DailyRecord.new(user: users(:one), recorded_on: Date.today, weight: -1)
    assert_not record.valid?
    assert_includes record.errors[:weight], "は0より大きい値にしてください"

    record.weight = 201
    assert_not record.valid?
    assert_includes record.errors[:weight], "は200より小さい値にしてください"
  end

  test "body_fat_percentage validation" do
    record = DailyRecord.new(user: users(:one), recorded_on: Date.today, body_fat_percentage: -1)
    assert_not record.valid?
    assert_includes record.errors[:body_fat_percentage], "は0より大きい値にしてください"

    record.body_fat_percentage = 101
    assert_not record.valid?
    assert_includes record.errors[:body_fat_percentage], "は100より小さい値にしてください"
  end

  test "recorded_on cannot be in the future" do
    record = DailyRecord.new(user: users(:one), recorded_on: Date.tomorrow)
    assert_not record.valid?
    assert_includes record.errors[:recorded_on], "は未来日を指定できません"
  end

  test "belongs to user" do
    record = daily_records(:one)
    assert_respond_to record, :user
    assert_instance_of User, record.user
  end

  test "has many habit_checks" do
    record = daily_records(:one)
    assert_respond_to record, :habit_checks
  end

  test "has many habits through habit_checks" do
    record = daily_records(:one)
    assert_respond_to record, :habits
  end

  test "recent scope orders by recorded_on desc" do
    recent_records = DailyRecord.recent
    assert_equal daily_records(:one).recorded_on, recent_records.first.recorded_on
  end

  test "motivation enum works" do
    record = daily_records(:one)
    record.motivation = "🙂"
    assert_equal "🙂", record.motivation
    assert_equal 2, record[:motivation]
  end
end
