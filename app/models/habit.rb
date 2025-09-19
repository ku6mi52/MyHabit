class Habit < ApplicationRecord
  belongs_to :user
  has_many :habit_checks, dependent: :destroy
	 
	enum difficulty: { normal: 0, easy: 1 }
	validates :name, presence: true, length: { maximum: 50 }
	
	scope :recent, -> { order(created_at: :desc) }
	
	def checked?(date = Date.current)
		habit_checks.exists?(checke_on: date)
	end
end
