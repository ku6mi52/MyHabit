class Habit < ApplicationRecord
  belongs_to :user
  has_many :habit_checks, dependent: :destroy
  has_many :daily_records, through: :habit_checks
	 
	enum difficulty: { normal: 0, easy: 1 }
	validates :name, presence: true, length: { maximum: 50 }
	
	scope :recent, -> { order(created_at: :desc) }
end
