class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :daily_records, dependent: :destroy
  has_many :habits, dependent: :destroy

	with_options on: :onboarding_step1 do
    validates :start_weight, presence: true, numericality: { greater_than: 0, less_than: 200 }
              
	  validates :start_body_fat_percentage, allow_nil: true, numericality: { greater_than: 0, less_than: 100 }
  end         
	with_options on: :onboarding_step2 do
    validates :goal_weight, presence: true, numericality: { greater_than: 0, less_than: 200 }
              
    validates :goal_body_fat_percentage, allow_nil: true, numericality: { greater_than: 0, less_than: 100 }
              
  end

  def onboarding_missing_step
      return :step1 if start_weight.blank?
      return :step2 if goal_weight.blank?
      nil
  end

  def daily_record_on(date)
	  daily_records.find_by(recorded_on: date)
	end

  def goal_weight_diff_on(date)
    dr = daily_records.find_by(recorded_on: date)
    return nil unless dr&.weight.present? && goal_weight.present?
    goal_weight - dr.weight
	end
end
