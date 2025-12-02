require "application_system_test_case"

class HappyPathTest < ApplicationSystemTestCase
  test "user registers, logs in, creates daily record, creates habit, and checks habit" do
    # ユーザー登録
    visit new_user_registration_path

    fill_in "メールアドレス", with: "happyuser@example.com"
    fill_in "パスワード ※アルファベット6文字以上", with: "password123"
    fill_in "パスワード（確認用）", with: "password123"

    click_on "登録"

    assert_text "アカウント登録が完了しました"

    # オンボーディング（現在の体重・目標体重を入力）
    # Step1: 現在の体重
    fill_in "現在の体重 (kg)", with: "70.0"
    fill_in "現在の体脂肪率 (%)", with: "25.0"
    click_on "登録する"

    # Step2: 目標体重
    fill_in "目標の体重 (kg)", with: "65.0"
    fill_in "目標の体脂肪率 (%)", with: "18.0"
    click_on "登録する"

    # ダッシュボードに遷移
    assert_current_path dashboard_path

    # 習慣を登録
    visit new_habit_path

    fill_in "項目名", with: "毎日ランニング"
    click_on "保存"

    assert_text "習慣を作成しました！"
    assert_text "毎日ランニング"

    # ダッシュボードに戻る
    visit dashboard_path

    # 日々の記録を登録
    fill_in "体重", with: "69.5"
    fill_in "体脂肪率", with: "20.0"
    find('input[type="radio"][value="🙂"]').click

    # 最初の保存ボタンをクリック（日々の記録用）
    all('input[type="submit"][value="保存"]').first.click

    assert_text "記録を更新しました！"

    # ダッシュボードに戻る
    visit dashboard_path

    # 習慣をチェック
    check "毎日ランニング"

    # 習慣チェックの保存ボタンをクリック
    all('input[type="submit"][value="保存"]').last.click

    assert_text "習慣チェックを記録しました！"

    # 記録一覧ページで確認
    click_on "記録一覧"

    assert_text "69.5"
    assert_text "20.0"
    assert_text "100%"  # 習慣達成率
  end
end
