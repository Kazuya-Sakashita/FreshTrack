class JobSchedulesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_job_schedule, only: %i[show edit update]

  def show
    # set_job_scheduleで取得済みの@job_scheduleを使用
  end

  def new
    if current_user.job_schedule
      redirect_to edit_job_schedule_path(current_user.job_schedule), notice: '既にスケジュールが存在します。'
    else
      @job_schedule = current_user.build_job_schedule
    end
  end

  def create
    @job_schedule = current_user.build_job_schedule(job_schedule_params)

    if @job_schedule.save
      ScheduleManager.update_schedule_for_user(current_user)
      redirect_to job_schedule_path(@job_schedule), notice: 'スケジュールが保存されました。'
    else
      flash[:alert] = @job_schedule.errors.full_messages.join(', ')
      render :new
    end
  end

  def edit
    # set_job_scheduleで取得済みの@job_scheduleを使用
  end

  def update
    if @job_schedule.update(job_schedule_params)
      redirect_to job_schedule_path, notice: 'スケジュールが更新されました。'
    else
      render :edit
    end
  end

  private

  def set_job_schedule
    @job_schedule = current_user.job_schedule
    unless @job_schedule
      redirect_to new_job_schedule_path, notice: 'スケジュールが存在しません。'
    end
  end

  def job_schedule_params
    params.require(:job_schedule).permit(:cron)
  end
end
