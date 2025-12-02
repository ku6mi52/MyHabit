class Users::SessionsController < Devise::SessionsController
  # ゲストユーザーでログイン
  def guest_sign_in
    guest_user = User.find_by(email: "guest@example.com")

    # ゲストユーザーが存在しない場合は作成
    unless guest_user
      guest_user = create_guest_user
    end

    sign_in guest_user
    redirect_to authenticated_root_path, notice: "ゲストユーザーとしてログインしました"
  end

  private

  def create_guest_user
    # トランザクション内でゲストユーザーとサンプルデータを作成
    User.transaction do
      guest_user = User.create!(
        email: "guest@example.com",
        password: "password",
        password_confirmation: "password",
        username: "ゲストユーザー",
        start_weight: 65.0,
        start_body_fat_percentage: 20.0,
        goal_weight: 60.0,
        goal_body_fat_percentage: 15.0,
        onboarding_completed_at: Time.current
      )

      # ゲストユーザーの習慣データ
      habits_data = [
        { name: "筋トレ", difficulty: 2 },
        { name: "ランニング", difficulty: 2 },
        { name: "野菜を食べる", difficulty: 1 },
        { name: "読書", difficulty: 0 },
        { name: "早起き", difficulty: 1 }
      ]

      habits = habits_data.map do |habit_data|
        guest_user.habits.create!(
          name: habit_data[:name],
          difficulty: habit_data[:difficulty],
          started_on: 30.days.ago,
          active: true
        )
      end

      # ゲストユーザーの過去30日分のデイリーレコードとハビットチェックを作成
      30.times do |i|
        date = (30 - i).days.ago.to_date

        daily_record = guest_user.daily_records.create!(
          recorded_on: date,
          weight: 65.0 - (i * 0.15),
          body_fat_percentage: 20.0 - (i * 0.1),
          motivation: [ "😖", "😑", "🙂", "😆" ].sample
        )

        # ランダムに習慣をチェック（70%の確率でチェック）
        habits.each do |habit|
          daily_record.habit_checks.create!(
            habit: habit,
            done: rand < 0.7
          )
        end
      end

      guest_user
    end
  end
end
