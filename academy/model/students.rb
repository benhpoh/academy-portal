require 'pg'
require 'bcrypt'
require 'httparty'

def run_sql(sql, params)
    conn = PG.connect(dbname:'academy')
    records = conn.exec_params(sql, params)
    conn.close
    records
end

def list_all_students()
    run_sql("SELECT * FROM students ORDER BY name;", [])
end

def list_active_students()
    run_sql("SELECT * FROM students WHERE graduated IS NULL AND batch_number IS NOT NULL ORDER BY name;", [])
end

def list_unassigned_students()
    run_sql("SELECT * FROM students WHERE batch_number IS NULL ORDER BY name;", [])
end

def list_graduated_students()
    run_sql("SELECT * FROM students WHERE graduated IS true ORDER BY name;", [])
end

def list_active_batches(students)
    active_batches = []
    students.each do |student|
        active_batches << student["batch_number"].to_i
    end
    active_batches.sort.uniq!
end

def list_students_by_batch_number(batch_number)
    records = run_sql("SELECT * FROM students WHERE batch_number = $1 AND graduated IS NULL ORDER BY name;", [batch_number])
    if records.count == 0
        return nil
    else
        return records
    end
end

def list_student_by_id(id)
    records = run_sql("SELECT * FROM students WHERE ID = $1;", [id])
    if records.count == 0
        return nil
    else
        return records[0]
    end
end

def create_student()
    url = "https://randomuser.me/api/?nat=au"
    student = HTTParty.get(url)["results"][0]
    name = student["name"]["first"] + " " + student["name"]["last"]
    password = "student"
    password_digested = BCrypt::Password.create(password)

    run_sql("INSERT INTO students (name, email, mobile, image_url, password_digested) VALUES ($1, $2, $3, $4, $5);", [name, student["email"], student["cell"], student["picture"]["large"], password_digested])
end

def update_student_details_by_id(id, name, email, mobile, image_url, password)
    password_digested = BCrypt::Password.create(password)

    run_sql("UPDATE students SET name = $1, email = $2, mobile = $3, image_url = $4, password_digested = $5 WHERE id = $6;",[name, email, mobile, image_url, password_digested, id])
end

def update_student_batch_number_by_id(id, batch_number)
    run_sql("UPDATE students SET batch_number = $1 WHERE id = $2;",[batch_number, id])
end

def graduate_student_by_id(id)
    run_sql("UPDATE students SET graduated = true WHERE id = $1;", [id])
end

def delete_student_by_id(id)
    run_sql("DELETE FROM students WHERE ID = $1;", [id])
end