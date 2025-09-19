class Onboarding < ActiveRecord::Migration[7.2]
  def change
    change_column_null :users, :start_weight, true
    change_column_null :users, :goal_weight, true
    add_column :users, :onboarding_completed_at, :datetime
  end
end
