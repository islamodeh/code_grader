class Instructor::WorksController < Instructor::InstructorsController
  
  def new
    @course = current_instructor.courses.find_by(id: params[:course_id])
    @work = @course.works.new
  end

  def create
    work = current_instructor.courses.find_by(id: params[:course_id]).works.new(params_require)
    work.zone_name = get_zone_name
    work.save
    if work.valid?
      flash[:success] = "#{work.work_type} created !"
    else
      flash[:danger] = work.errors.full_messages.join(", ")
    end
    redirect_to instructor_course_path(work)
  end
  
  def show
    @work = current_instructor.courses.find_by(id: params[:course_id]).works.find_by(id: params[:id])
  end
  
  def edit
    @course = current_instructor.courses.find_by(id: params[:course_id])
    @work = @course.works.find_by(id: params[:id])
  end
  
  def update
    course = current_instructor.courses.find_by(id: params[:course_id])
    work = course.works.find_by(id: params[:id])
    work.zone_name = get_zone_name

    if work.update(params_require)
      flash[:success] = "#{work.work_type} Updated!"
    else
      flash[:danger] = work.errors.full_messages.join(", ")
    end
    redirect_to instructor_course_path(course)
  end
  
  private
  def params_require
    params.require(:work).permit(:name, :work_type, :description, :start_date, :end_date)
  end
end