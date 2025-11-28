class Habit < ApplicationRecord
  belongs_to :user
  has_many :habit_checks, dependent: :destroy
  has_many :daily_records, through: :habit_checks

  validates :name, presence: true, length: { maximum: 50 }

  scope :recent, -> { order(created_at: :desc) }
end
