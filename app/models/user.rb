class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :daily_records, dependent: :destroy
  has_many :habits

	with_options on: :onboarding_step1 do
    validates :start_weight, presence: true, numericality: { greater_than: 0, less_than: 200 }
              
	  validates :start_body_fat_percentage, allow_nil: true, numericality: { greater_than: 0, less_than: 100 }
  end         
	with_options on: :onboarding_step2 do
    validates :goal_weight, presence: true, numericality: { greater_than: 0, less_than: 200 }
              
    validates :goal_body_fat_percentage, allow_nil: true, numericality: { greater_than: 0, less_than: 100 }
              
  end

  attr_readonly :start_weight, :body_fat_percentage

  def onboarding_missing_step
      return :step1 if start_weight.blank?
      return :step2 if goal_weight.blank?
      nil
  end

end
