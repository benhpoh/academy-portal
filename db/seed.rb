require 'pg'
require 'bcrypt'
require 'httparty'

require_relative "../lib"
require_relative "../model/students"
require_relative "../model/staff"

print "Starting batch number: "
num = gets.chomp.to_i

10.times do
    create_student
end

run_sql("update students set batch_number = #{num} where batch_number is null;",[])

10.times do
    create_student
end

run_sql("update students set batch_number = #{num + 1} where batch_number is null;",[])