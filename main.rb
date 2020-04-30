require "sinatra"
require "sinatra/reloader" if development?
require 'pg'
require 'bcrypt'
require 'httparty'

require_relative "lib"
require_relative "model/staff"
require_relative "model/students"

enable :sessions

before do
  $url_path = request.path.split("/")
end

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
  url_tab = $url_path[1]
  active_students = list_active_students
  unassigned_students = list_unassigned_students
  all_students = list_all_students

  erb :dash_show, locals: {
    user: user, 
    url_tab: url_tab,
    all_students: all_students,
    active_students: active_students,
    unassigned_students: unassigned_students
  }
end

post "/main/student/new" do
  create_student
  redirect "/main"
end

get "/main/students" do
  redirect "/" unless logged_in?
  batch_number = nil

  user = list_staff_by_id(session["user_id"])
  url_tab = $url_path[2]
  active_students = list_active_students
  active_batches = list_active_batches(active_students)
  batch_students = list_students_by_batch_number(batch_number)
  sel_student = list_student_by_id(params["id"])

  erb :students_show, locals: {
    user: user, 
    url_tab: url_tab,
    batch_number: batch_number,
    active_batches: active_batches,
    batch_students: batch_students,
    sel_student: sel_student
  }
end

get "/main/students/all" do
  redirect "/" unless logged_in?
  batch_number = nil

  user = list_staff_by_id(session["user_id"])
  url_tab = $url_path[2]
  active_students = list_active_students
  active_batches = list_active_batches(active_students)
  sel_student = list_student_by_id(params["id"])


  erb :students_show, locals: {
    user: user, 
    url_tab: url_tab,
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
  url_tab = $url_path[2]
  active_students = list_active_students
  active_batches = list_active_batches(active_students)
  batch_students = list_graduated_students
  sel_student = list_student_by_id(params["id"])


  erb :students_show, locals: {
    user: user, 
    url_tab: url_tab,
    batch_number: batch_number,
    active_batches: active_batches,
    batch_students: batch_students,
    sel_student: sel_student
  }
end

get "/main/students/edit/:id" do
  redirect "/" unless logged_in?
  user = list_staff_by_id(session["user_id"])
  url_tab = $url_path[2]
  sel_student = list_student_by_id(params["id"])
  
  erb :students_edit, locals: {
    user: user,
    url_tab: url_tab,
    sel_student: sel_student
  }
end

patch "/main/student" do
  update_student_details_by_id(params["id"], params["name"], params["email"], params["mobile"], params["image_url"], params["batch_number"], params["graduated"])
  redirect "/main/students/batch-#{params["batch_number"]}/#{params["id"]}"
end

get "/main/students/:batch" do
  redirect "/" unless logged_in?
  batch_number = params["batch"][6..-1]

  user = list_staff_by_id(session["user_id"])
  url_tab = $url_path[2]
  active_students = list_active_students
  active_batches = list_active_batches(active_students)
  batch_students = list_students_by_batch_number(batch_number)
  sel_student = list_student_by_id(params["id"])

  erb :students_show, locals: {
    user: user, 
    url_tab: url_tab,
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
  url_tab = $url_path[2]
  active_students = list_active_students
  active_batches = list_active_batches(active_students)
  batch_students = list_students_by_batch_number(batch_number)
  sel_student = list_student_by_id(params["id"])

  erb :students_show, locals: {
    user: user, 
    url_tab: url_tab,
    batch_number: batch_number,
    active_batches: active_batches,
    batch_students: batch_students,
    sel_student: sel_student
  }
end

patch "/main/students/graduate" do
  graduate_student_by_id(params["id"])
  redirect "/main/students/batch-#{params["batch_number"]}"
end

get "/main/batches" do
  redirect "/" unless logged_in?
  user = list_staff_by_id(session["user_id"])
  url_tab = $url_path[2]
  active_students = list_active_students
  active_batches = list_active_batches(active_students)
  unassigned_students = list_unassigned_students

  erb :batches_show, locals: {
    user: user, 
    url_tab: url_tab,
    active_batches: active_batches,
    unassigned_students: unassigned_students,
    batch: nil
  }
end

get "/main/batches/:batch" do
  redirect "/" unless logged_in?
  user = list_staff_by_id(session["user_id"])
  url_tab = $url_path[2]
  active_students = list_active_students
  active_batches = list_active_batches(active_students)
  unassigned_students = list_unassigned_students
  batch_students = list_students_by_batch_number(params["batch"])

  erb :batches_show, locals: {
    user: user, 
    url_tab: url_tab,
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
  url_tab = $url_path[2]
  active_students = list_active_students
  active_batches = list_active_batches(active_students)
  unassigned_students = list_unassigned_students
  batch_students = list_students_by_batch_number(params["batch"])
  sel_student = list_student_by_id(params["id"])

  erb :batches_show, locals: {
    user: user, 
    url_tab: url_tab,
    active_batches: active_batches,
    unassigned_students: unassigned_students,
    batch_students: batch_students,
    batch: params["batch"],
    sel_student: sel_student
  }
end

patch "/main/batches/assign" do
  update_student_batch_number_by_id(params["id"], params["batch_number"])
  redirect "/main/batches/#{params["batch_number"]}"
end

get "/main/admin" do
  redirect "/" unless logged_in?
  
  user = list_staff_by_id(session["user_id"])
  url_tab = $url_path[2]

  erb :admin_show, locals: {
    user: user,
    url_tab: url_tab
  }
end

get "/main/admin/new" do
  redirect "/" unless logged_in?
  
  user = list_staff_by_id(session["user_id"])
  url_tab = $url_path[2]

  erb :admin_new, locals: {
    user: user,
    url_tab: url_tab
  }
end

post "/main/admin" do
  create_staff(params["name"], params["email"], params["position"], params["password"])
  user = list_staff_by_id(session["user_id"])
  erb :admin_created_show, locals: {
    user: user,
    new_staff_name: params["name"]
  }
end