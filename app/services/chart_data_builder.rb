class ChartDataBuilder
  def initialize(user:, date: Date.current)
    @user = user
    @date = date
  end

  def build
    {
      labels: labels,
      weights: weights,
      rates: rates
    }
  end

  private

  attr_reader :user, :date

  def start_date
    @start_date ||= date.beginning_of_month
  end

  def end_date
    @end_date ||= date.end_of_month
  end

  def records
    @records ||= user.daily_records
                     .where(recorded_on: start_date..end_date)
                     .select(:id, :recorded_on, :weight, :user_id)
                     .order(:recorded_on)
  end

  def rates_by_id
    @rates_by_id ||= HabitCheck.tasks_completion_rate(records) || {}
  end

  def last_day
    @last_day ||= end_date.day
  end

  def labels
    @labels ||= (1..last_day).to_a
  end

  def weights
    @weights ||= build_weights_array
  end

  def rates
    @rates ||= build_rates_array
  end

  def build_weights_array
    result = Array.new(last_day)
    records.each do |record|
      day_index = record.recorded_on.day - 1
      result[day_index] = record.weight
    end
    result
  end

  def build_rates_array
    result = Array.new(last_day)
    records.each do |record|
      day_index = record.recorded_on.day - 1
      result[day_index] = rates_by_id[record.id]
    end
    result
  end
end
