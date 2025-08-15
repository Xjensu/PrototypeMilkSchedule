class Admin::DeletedSchedulesController < ApplicationController
  before_action :get_deleted, only: [:destroy]
  def create
    service = DeletedScheduleService.new(create_params)
    @deleted = service.create

    if @deleted
      puts "da"
    else
      puts "net"
    end
  end

  def destroy
    @target = params[:target]
    service = DeletedScheduleService.new( id: @deleted.id )
    respond_to do |format|
      if service.destroy
        format.turbo_stream
      else
        puts "net"
      end
    end
  end

  private 

  def create_params
    params.require(:deleted_schedule).permit(:schedule_id, :date, :student_group_id, :course)
  end

  def get_deleted
    @deleted = DeletedSchedule.find(params[:id])
  end
end
