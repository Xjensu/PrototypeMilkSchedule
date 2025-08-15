class Admin::AddedSchedulesController < Admin::BaseAdminController
  before_action :get_added, only: [:destroy]
  def create
    service = AddedScheduleService.new(create_params)
    @added = service.create

    if @added
      puts "da"
    else
      puts "net"
    end
  end

  def destroy
    @target = params[:target]
    service = AddedScheduleService.new( id: @added.id )
    respond_to do |format|
      if service.destroy
        format.turbo_stream
      else
        puts "net"
      end
    end
  end

  def edit
    puts "PARAMS", edit_params[:teacher_id].present?
    @change = AddedSchedule.includes(:schedule,:teacher,:classroom).find(params[:id])
    @teacher_id = edit_params[:teacher_id].present? ? edit_params[:teacher_id] : @change.schedule.teacher_id
    @classroom_id = edit_params[:classroom_id].present? ? edit_params[:classroom_id] : @change.schedule.classroom_id

    @classrooms = Classroom.all
    @teachers = TeachersFetcher.new(
      search_query: params[:teacher_search],
      limit: params[:teacher_search].present? ? 10 : nil,
      priority_teacher_id: @selected_teacher_id,
    ).call.order(name: :asc)

    respond_to do |format|
      format.turbo_stream
    end
  end

  def update
    puts "PARAMS", params

    @change = AddedSchedule.find(params[:id])

    respond_to do |format|
      if @change.update(edit_params)
        format.turbo_stream
      end
    end
  end

  private 

  def create_params
    params.require(:deleted_schedule).permit(:schedule_id, :date, :student_group_id, :course)
  end

  def get_added
    @added = AddedSchedule.find(params[:id])
  end

  def edit_params
    params.require(:added_schedule).permit(:teacher_id, :classroom_id)
  end
end
