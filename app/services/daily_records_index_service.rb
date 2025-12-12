class DailyRecordsIndexService
  def initialize(user:, page: 1)
    @user = user
    @page = page
  end

  def call
    {
      months: paginated_months,
      dates: dates,
      daily_records: daily_records_by_date,
      rates: completion_rates
    }
  end

  private

  attr_reader :user, :page

  def first_record_date
    @first_record_date ||= user.daily_records.minimum(:recorded_on)&.to_date || Time.zone.today
  end

  def months_count
    @months_count ||= begin
      (Time.zone.today.year * 12 + Time.zone.today.month) -
        (first_record_date.year * 12 + first_record_date.month) + 1
    end
  end

  def all_months
    @all_months ||= Array.new(months_count) { |i| Time.zone.today.beginning_of_month << i }
  end

  def paginated_months
    @paginated_months ||= Kaminari.paginate_array(all_months, total_count: months_count)
                                   .page(page)
                                   .per(1)
  end

  def current_month
    @current_month ||= paginated_months.first || Time.zone.today.beginning_of_month
  end

  def date_range_start
    @date_range_start ||= current_month.beginning_of_month
  end

  def date_range_end
    @date_range_end ||= [ current_month.end_of_month, Time.zone.today ].min
  end

  def dates
    @dates ||= (date_range_start..date_range_end).to_a
  end

  def daily_records_collection
    @daily_records_collection ||= user.daily_records.where(recorded_on: dates)
  end

  def daily_records_by_date
    @daily_records_by_date ||= daily_records_collection.index_by(&:recorded_on)
  end

  def completion_rates
    @completion_rates ||= HabitCheck.tasks_completion_rate(daily_records_collection)
  end
end
