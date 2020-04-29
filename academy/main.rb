require "sinatra/reloader"
require "sinatra"

require_relative "lib"
require_relative "model/staff"
require_relative "model/students"

enable :sessions

get "/" do
  erb :index
end

post "/login" do
  user = list_staff_by_email(params["email"])
  if user && BCrypt::Password.new(user["password_digested"]) == params["password"]
    session["user_id"] = user["id"]
    redirect "/main"
  else
    erb :index
  end
end

delete "/logout" do
  session["user_id"] = nil
  redirect "/"
end

get "/main" do
  redirect "/" unless logged_in?
  user = list_staff_by_id(session["user_id"])
  active_students = list_active_students
  unassigned_students = list_unassigned_students
  all_students = list_all_students

  erb :dash_show, locals: {
    user: user, 
    all_students: all_students,
    active_students: active_students,
    unassigned_students: unassigned_students
  }
end

post "/main/new" do
  create_student
  redirect "/main"
end

get "/main/students" do
  redirect "/" unless logged_in?
  batch_number = nil

  user = list_staff_by_id(session["user_id"])
  # all_students = list_all_students
  # unassigned_students = list_unassigned_students
  active_students = list_active_students
  active_batches = list_active_batches(active_students)
  batch_students = list_students_by_batch_number(batch_number)
  sel_student = list_student_by_id(params["id"])


  erb :students_show, locals: {
    user: user, 
    batch_number: batch_number,
    # all_students: all_students,
    # active_students: active_students,
    # unassigned_students: unassigned_students,
    active_batches: active_batches,
    batch_students: batch_students,
    sel_student: sel_student
  }
end

get "/main/students/all" do
  redirect "/" unless logged_in?
  batch_number = nil

  user = list_staff_by_id(session["user_id"])
  active_students = list_active_students
  active_batches = list_active_batches(active_students)
  sel_student = list_student_by_id(params["id"])


  erb :students_show, locals: {
    user: user, 
    batch_number: batch_number,
    active_batches: active_batches,
    batch_students: active_students,
    sel_student: sel_student
  }
end

get "/main/students/alumni" do
  redirect "/" unless logged_in?
  batch_number = nil

  user = list_staff_by_id(session["user_id"])
  active_students = list_active_students
  active_batches = list_active_batches(active_students)
  batch_students = list_graduated_students
  sel_student = list_student_by_id(params["id"])


  erb :students_show, locals: {
    user: user, 
    batch_number: batch_number,
    active_batches: active_batches,
    batch_students: batch_students,
    sel_student: sel_student
  }
end

get "/main/students/:batch" do
  redirect "/" unless logged_in?
  batch_number = params["batch"][6..-1]

  user = list_staff_by_id(session["user_id"])
  active_students = list_active_students
  active_batches = list_active_batches(active_students)
  batch_students = list_students_by_batch_number(batch_number)
  sel_student = list_student_by_id(params["id"])

  erb :students_show, locals: {
    user: user, 
    batch_number: batch_number,
    active_batches: active_batches,
    batch_students: batch_students,
    sel_student: sel_student
  }
end

get "/main/students/:batch/:id" do
  redirect "/" unless logged_in?
  batch_number = params["batch"][6..-1]

  user = list_staff_by_id(session["user_id"])
  active_students = list_active_students
  active_batches = list_active_batches(active_students)
  batch_students = list_students_by_batch_number(batch_number)
  sel_student = list_student_by_id(params["id"])

  erb :students_show, locals: {
    user: user, 
    batch_number: batch_number,
    active_batches: active_batches,
    batch_students: batch_students,
    sel_student: sel_student
  }
end

patch "/main/students/graduate" do
  graduate_student_by_id(params["id"])
  redirect "/main/students/alumni"
end

get "/main/batches" do
  redirect "/" unless logged_in?
  user = list_staff_by_id(session["user_id"])
  active_students = list_active_students
  active_batches = list_active_batches(active_students)
  unassigned_students = list_unassigned_students

  erb :batches_show, locals: {
    user: user, 
    active_batches: active_batches,
    unassigned_students: unassigned_students,
    batch: nil
  }
end

get "/main/batches/:batch" do
  redirect "/" unless logged_in?
  user = list_staff_by_id(session["user_id"])
  active_students = list_active_students
  active_batches = list_active_batches(active_students)
  unassigned_students = list_unassigned_students
  batch_students = list_students_by_batch_number(params["batch"])

  erb :batches_show, locals: {
    user: user, 
    active_batches: active_batches,
    unassigned_students: unassigned_students,
    batch_students: batch_students,
    batch: params["batch"],
    sel_student: nil
  }
end

get "/main/batches/:batch/:id" do
  redirect "/" unless logged_in?
  user = list_staff_by_id(session["user_id"])
  active_students = list_active_students
  active_batches = list_active_batches(active_students)
  unassigned_students = list_unassigned_students
  batch_students = list_students_by_batch_number(params["batch"])
  sel_student = list_student_by_id(params["id"])

  erb :batches_show, locals: {
    user: user, 
    active_batches: active_batches,
    unassigned_students: unassigned_students,
    batch_students: batch_students,
    batch: params["batch"],
    sel_student: sel_student
  }
end

patch "/main/batches/assign" do
  update_student_batch_number_by_id(params["id"], params["batch_number"])
  redirect "/main/students/batch-#{params["batch_number"]}/#{params["id"]}"
end

