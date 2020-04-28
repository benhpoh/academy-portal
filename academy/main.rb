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
  current_students = run_sql("SELECT * FROM students WHERE graduated IS NULL AND batch_number IS NOT NULL;", [])
  unassigned_students = run_sql("SELECT * FROM students WHERE batch_number IS NULL;", [])
  students = list_all_students
  erb :dash_show, locals: {user: user, students: students}
end




