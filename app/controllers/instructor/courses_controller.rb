class Instructor::CoursesController < Instructor::InstructorsController
  def index
    @courses = current_instructor.courses
  end

  def new
    @course = Course.new
  end

  def create
    if (course = current_instructor.courses.create(params_require)) && course.valid?
      flash[:success] = "Course created Succesfully!"
    else
      flash[:danger] = course.errors.full_messages.join(", ")
    end
    redirect_to(instructor_courses_path)
  end

  def edit
    @course = current_instructor.courses.find_by(id: params[:id])
  end

  def update
    @course = current_instructor.courses.find_by(id: params[:id])
    if @course.present? && @course.update(params_require)
      flash[:success] = "Course Updated!"
    else
      flash[:danger] = @course.errors.full_messages.join(", ")
    end
    redirect_to(instructor_courses_path)
  end

  def destroy
    @course = current_instructor.courses.find_by(id: params[:id])
    flash[:success] = "#{@course.name} deleted Succesfully!" if @course.destroy
    redirect_to(instructor_courses_path)
  end

  def students
    @course = current_instructor.courses.find_by(id: params[:id])
    @pending_students = @course.pending_students.includes(:student)
    @enrolled_students = @course.enrolled_students.includes(:student)
  end

  def handle_enrollment
    course = current_instructor.courses.find_by(id: params[:course])
    enrollment = course.enrollments.find_by(student_id: params[:student_id])
    if enrollment.status == "Pending"
      if params[:status] == "Accepted"
        enrollment.update(status: "Accepted")
        flash[:success] = "Accepted student"
      else
        flash[:danger] = "Declined student request"
        enrollment.destroy
      end
    elsif params[:status] == "Kick"
      flash[:danger] = "Kicked student from course"
      enrollment.destroy
    end
    redirect_to(students_instructor_course_path(course))
  end

  def grades
    @course = current_instructor.courses.find_by(id: params[:id])
    @works = @course.works.order(created_at: :asc).includes(:submissions)
    @enrolled_students = @course.enrolled_students.includes(:student)
  end

  private

  def params_require
    params.require(:course).permit(:name, :section, :description)
  end
end
