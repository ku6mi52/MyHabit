class HabitsController < ApplicationController
	before_action :authenticate_user!
	before_action :set_habit, only: [:edit, :update, :destroy]

	def index
		@habits = current_user.habits.recent
	end
	
	def new
		@habit = current_user.habits.new(started_on: Date.current)
	end
	
	def create
		@habit = current_user.habits.new(habit_params)
		if @habit.save
			redirect_to habits_path, notice: "習慣を作成しました！"
		else
			flash.now[:alert] = "習慣の作成に失敗しました"
			render :new, status: :unprocessable_entity
		end
	end
	
	def edit; end
	
	def update
		if @habit.update(habit_params)
			redirect_to habits_path, notice: "習慣を更新しました！"
		else
			flash.now[:alert] = "習慣の更新に失敗しました"
			render :edit, status: :unprocessable_entity
		end
	end
	
	def destroy
		@habit.destroy
		redirect_to habits_path, notice: "習慣を削除しました！"
	end
	
	private
	
	def set_habit
		@habit = current_user.habits.find(params[:id])
	end
	
	def habit_params
		params.require(:habit).permit(:name, :difficulty, :started_on)
	end
end
