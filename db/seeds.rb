# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# ゲストユーザーの作成
guest_user = User.find_or_create_by!(email: "guest@example.com") do |user|
  user.password = "password"
  user.password_confirmation = "password"
  user.username = "ゲストユーザー"
  user.start_weight = 65.0
  user.start_body_fat_percentage = 20.0
  user.goal_weight = 60.0
  user.goal_body_fat_percentage = 15.0
  user.onboarding_completed_at = Time.current
end

# ゲストユーザーの習慣データ
habits_data = [
  { name: "筋トレ", difficulty: 2 },
  { name: "ランニング", difficulty: 2 },
  { name: "野菜を食べる", difficulty: 1 },
  { name: "読書", difficulty: 0 },
  { name: "早起き", difficulty: 1 }
]

habits_data.each do |habit_data|
  guest_user.habits.find_or_create_by!(name: habit_data[:name]) do |habit|
    habit.difficulty = habit_data[:difficulty]
    habit.started_on = 30.days.ago
    habit.active = true
  end
end

# ゲストユーザーの過去30日分のデイリーレコードとハビットチェックを作成
30.times do |i|
  date = (30 - i).days.ago.to_date

  daily_record = guest_user.daily_records.find_or_create_by!(recorded_on: date) do |record|
    # 徐々に減少する体重と体脂肪率
    record.weight = 65.0 - (i * 0.15)
    record.body_fat_percentage = 20.0 - (i * 0.1)
    record.motivation = ["😖", "😑", "🙂", "😆"].sample
  end

  # ランダムに習慣をチェック（70%の確率でチェック）
  guest_user.habits.each do |habit|
    done = rand < 0.7
    daily_record.habit_checks.find_or_create_by!(habit: habit) do |check|
      check.done = done
    end
  end
end

puts "ゲストユーザーのシードデータを作成しました"
puts "Email: guest@example.com"
puts "Password: password"
