class Users::SessionsController < Devise::SessionsController
  # ゲストユーザーでログイン
  def guest_sign_in
    guest_user = User.find_by(email: "guest@example.com")

    unless guest_user
      redirect_to new_user_session_path, alert: "ゲストユーザーが見つかりません。seedデータを実行してください。"
      return
    end

    sign_in guest_user
    redirect_to authenticated_root_path, notice: "ゲストユーザーとしてログインしました"
  end
end
