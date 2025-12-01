class DailyRecord < ApplicationRecord
  belongs_to :user
  has_many :habit_checks, dependent: :destroy
  has_many :habits, through: :habit_checks

  validates :recorded_on, presence: true, uniqueness: { scope: :user_id }
  validates :weight, allow_nil: true, numericality: { greater_than: 0, less_than: 200 }
  validates :body_fat_percentage, allow_nil: true, numericality: { greater_than: 0, less_than: 100 }

  enum :motivation, { "😖" => 0, "😑" => 1, "🙂" => 2, "😆" => 3 }

  validate :recorded_on_cannot_be_in_the_future

  scope :recent, -> { order(recorded_on: :desc) }

  private

  def recorded_on_cannot_be_in_the_future
    return if recorded_on.blank?
    errors.add(:recorded_on, "は未来日を指定できません") if recorded_on > Date.current
  end
end
