class Admin::DefaultSchedulesController < Admin::BaseAdminController
  before_action :load_initial_data, only: [:index]
  

  def index
    respond_to do |format|
      format.html do
        @schedule_renderer = ScheduleRenderer.new(
          self,
          default_times: @default_times,
          schedules: @schedules,
          param: { day: @day, group_id: @group_id, academic_period_id: @academic_period_id, course: @course },
          card_attributes: { "default-schedule": "card" }
        )
      end
    end
  end

  def create
    subject = processing_subjects( params[:schedule][:subject_id] )
    puts params

    @schedule = Schedule.new(
      create_params.merge("lesson_id": params[:lesson_id_input]).merge("subject_id": subject)
    )

    puts "CREATE", @schedule.attributes

    respond_to do |format|
      if @schedule.save
        format.turbo_stream
      else 
        format.turbo_stream { render :create_error }
      end
    end
  end


  def update
    @schedule = Schedule.find(params[:id])
    subject = processing_subjects( params[:schedule][:subject_id] )
    respond_to do |format|
      if @schedule.update(create_params.merge("subject_id": subject).merge("lesson_id": params[:lesson_id_input]))
        format.turbo_stream
      else 
        format.turbo_stream { render :update_error }
      end
    end
  end

  def destroy
    puts params
    @schedule = Schedule.find(params[:id])
    @schedule.destroy
    respond_to do |format|
      format.turbo_stream
    end
  end


  def editor
    load_data_from_params
    @lessons = Lesson.where(lesson_type: [:lecture, :pz, :lab])
    @teachers = TeachersFetcher.new(
      search_query: params[:teacher_search],
      limit: params[:teacher_search].present? ? 10 : nil,
      priority_teacher_id: @selected_teacher_id,
    ).call.order(name: :asc)
    
    @schedule = if @schedule_id.present?
                  Schedule.find(@schedule_id)
                else
                  Schedule.new(
                    student_group_id: @group_id,
                    academic_period_id: @academic_period_id,
                    day_of_week: @day,
                    start_time: @time,
                    course: @course,
                    under: @under
                  )
                end
    
    puts @schedule.attributes

    @classrooms = Classroom.all
    
    
    respond_to do |format|
      format.turbo_stream
    end
  end


  private

  def processing_subjects(param)
    return nil if param.blank?
    subject = Subject.where(name: param)
    if subject.present?
      subject = subject.ids.first
    else 
      subject = Subject.new(name: param.to_s)
      subject.save!
      subject = subject.id
    end
    subject
  end

  def load_data_from_params
    @group_id = params[:group_id] if params[:group_id]
    @academic_period_id = params[:academic_period_id]
    @day = params[:day] || '1'
    @time = params[:time]
    @schedule_id = params[:schedule_id]
    @under = params[:under]
    @course = params[:course]
  end

  def load_initial_data
    @query_params = request.query_parameters
    @group_id = params[:group_id]
    @course = params[:course]
    @academic_period_id = params[:academic_period_id]
    @default_times = ['8:30', '10:10', '11:45', '14:00', '15:35', '17:10', '18:45']
    @day =  params[:day] || '1'
    
    load_schedules
  end

  def load_schedules
    @schedules = Schedule.joins(:subject, :teacher, :classroom, :lesson, :student_group)
                        .where(
                          student_group_id: @group_id,
                          academic_period_id: @academic_period_id,
                          course: @course
                        ).order(Subject.arel_table[:name].lower.asc)
                        
    @schedules = @schedules.where(day_of_week: @day).order(:start_time)
    

  end



  def create_params
    params.require(:schedule).permit(:teacher_id, :academic_period_id, :student_group_id, :day_of_week, :start_time, :classroom_id, :lesson_id, :under, :subject_id, :course)
  end
end