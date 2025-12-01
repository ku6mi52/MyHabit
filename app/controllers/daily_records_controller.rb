class DailyRecordsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_daily_record, only: [ :edit, :update, :destroy ]

  def index
    first_on = current_user.daily_records.minimum(:recorded_on)&.to_date || Time.zone.today
    months_count = (Time.zone.today.year * 12 + Time.zone.today.month) -
                   (first_on.year * 12 + first_on.month) + 1

    months = Array.new(months_count) { |i| Time.zone.today.beginning_of_month << i }
    @months = Kaminari.paginate_array(months, total_count: months_count)
                      .page(params[:page]).per(1)

    current_month = @months.first || Time.zone.today.beginning_of_month
    from = current_month.beginning_of_month
    to = [ current_month.end_of_month, Time.zone.today ].min

    @dates = (from..to).to_a
    @daily_record = current_user.daily_records
                                .where(recorded_on: @dates)
    @daily_records = @daily_record.index_by(&:recorded_on)
    @rates = HabitCheck.tasks_completion_rate(@daily_record)
  end

  def new
    @daily_record = current_user.daily_records.new(recorded_on: Date.current)
  end

  def create
    @daily_record = current_user.daily_records.new(daily_record_params)
    if @daily_record.save
      redirect_to daily_records_path, notice: "記録を作成しました！"
    else
      flash.now[:alert] = "記録の作成に失敗しました"
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @daily_record.update(daily_record_params)
      redirect_to daily_records_path, notice: "記録を更新しました！"
    else
      flash.now[:alert] = "記録の更新に失敗しました"
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @daily_record.destroy!
    redirect_to daily_records_path, notice: "記録を削除しました！"
  end

  private

  def set_daily_record
    @daily_record = current_user.daily_records.find(params[:id])
  end

  def daily_record_params
    params.require(:daily_record).permit(:recorded_on, :weight, :body_fat_percentage, :motivation)
  end
end
