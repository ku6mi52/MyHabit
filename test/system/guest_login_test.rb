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

  test "guest login fails when guest user does not exist" do
    # ゲストユーザーが存在しない場合のテスト
    User.find_by(email: "guest@example.com")&.destroy

    visit new_user_session_path

    click_button "ゲストとしてログイン"

    # エラーメッセージが表示されることを確認
    assert_text "ゲストユーザーが見つかりません"
  end
end
