require "application_system_test_case"

class GuestLoginTest < ApplicationSystemTestCase
  test "guest user can login" do
    # ゲストユーザーが存在することを確認
    guest_user = User.find_or_create_by!(email: "guest@example.com") do |user|
      user.password = "password"
      user.password_confirmation = "password"
      user.username = "ゲストユーザー"
      user.onboarding_completed_at = Time.current
    end

    # ログインページにアクセス
    visit new_user_session_path

    # ゲストログインボタンが表示されていることを確認
    assert_text "ゲストとしてログイン"

    # ゲストログインボタンをクリック
    click_button "ゲストとしてログイン"

    # ダッシュボードにリダイレクトされることを確認
    assert_current_path authenticated_root_path

    # ログイン成功メッセージが表示されることを確認
    assert_text "ゲストユーザーとしてログインしました"
  end

  test "guest user is automatically created if not exists" do
    # ゲストユーザーが存在しない場合は自動生成されることを確認
    User.find_by(email: "guest@example.com")&.destroy

    visit new_user_session_path

    click_button "ゲストとしてログイン"

    # ダッシュボードにリダイレクトされることを確認
    assert_current_path authenticated_root_path

    # ログイン成功メッセージが表示されることを確認
    assert_text "ゲストユーザーとしてログインしました"

    # ゲストユーザーが作成されていることを確認
    assert User.exists?(email: "guest@example.com")
  end
end
