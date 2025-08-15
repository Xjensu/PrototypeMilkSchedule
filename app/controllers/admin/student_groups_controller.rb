class Admin::StudentGroupsController < ApplicationController
  def index
    @groups = StudentGroup.where(faculty_id: params[:faculty_id]).order(:group_name)
    @academic_periods = AcademicPeriod.where(faculty_id: params[:faculty_id])
  end

  def new
    @group = StudentGroup.new
  end

  def create
    @group = StudentGroup.new create_params

    respond_to do |format|
      if @group.save
        format.turbo_stream
      else
        format.turbo_stream { render :create_error }
      end
    end
  end

  def destroy
    @group = StudentGroup.find(params[:id])
    faculty_id = @group.faculty_id
    respond_to do |format|
      if @group.destroy
        @groups = StudentGroup.where(faculty_id: faculty_id).order(:group_name)
        format.turbo_stream
      else
        format.turbo_stream { render :destroy_error, status: :unprocessable_entity }
      end
    end
  end

  private

  def create_params
    params.require(:student_group).permit(:group_name, :faculty_id)
  end
end
