class Admin::TeachersController < ApplicationController
  def index
    @teachers = TeachersFetcher.new(
      search_query: params[:search],
      limit: params[:limit]
    ).call
    
    respond_to do |format|
      format.html
      format.turbo_stream
    end
  end

  def new
    @teacher = Teacher.new
  end

  def create
    @teacher = Teacher.new(teacher_params)
    
    respond_to do |format|
      if @teacher.save
        format.turbo_stream
      else
        format.turbo_stream { render :create_error }
      end
    end
  end

  def edit
    @teacher = Teacher.find(params[:id])
  end

  def update
    @teacher = Teacher.find(params[:id])
    
    respond_to do |format|
      if @teacher.update(teacher_params)
        format.turbo_stream
      else
        format.turbo_stream { render :edit }
      end
    end
  end

  def destroy
    @teacher = Teacher.find(params[:id])
    
    respond_to do |format|
      if @teacher.destroy
        format.turbo_stream
      else
        format.turbo_stream { render :destroy_error }
      end
    end
  end

  private

  def teacher_params
    params.require(:teacher).permit(:name, :surname, :patronymic, :post)
  end
end