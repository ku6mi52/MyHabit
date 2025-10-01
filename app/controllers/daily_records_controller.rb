class DailyRecordsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_daily_record, only: [:edit, :update, :destroy]

  def index
    to = Date.current
    from = to - 29.days
    all_dates = (from..to).to_a.reverse
    @dates = Kaminari.paginate_array(all_dates).page(params[:page]).per(30)
    @daily_record = current_user.daily_records.where(recorded_on: @dates)
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
    params.require(:daily_record).permit(:recorded_on, :weight, :body_fat_percentage)
  end
end

