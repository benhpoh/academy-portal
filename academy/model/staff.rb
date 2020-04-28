# require 'pg'
# require 'bcrypt'

# def run_sql(sql, params)
#     conn = PG.connect(dbname:'academy')
#     records = conn.exec_params(sql, params)
#     conn.close
#     records
# end

def list_all_staff()
    run_sql("SELECT * FROM staff ORDER BY id;", [])
end

def list_staff_by_id(id)
    records = run_sql("SELECT * FROM staff WHERE ID = $1;", [id])
    if records.count == 0
        return nil
    else
        return records[0]
    end
end

def list_staff_by_email(email)
    records = run_sql("SELECT * FROM staff WHERE email = $1;", [email])
    if records.count == 0
        return nil
    else
        return records[0]
    end
end

def create_staff(name, email, mobile, position, password)
    name = "Carol Danvers"
    email = "cd@ga.co"
    mobile = "0411 223 445"
    position = "Instructor"
    password = "staff"
    password_digested = BCrypt::Password.create(password)

    run_sql("INSERT INTO staff (name, email, mobile, position, password_digested) VALUES ($1, $2, $3, $4, $5);", [name, email, mobile, position, password_digested])
end

def update_staff_by_id(id, name, email, mobile, position, password)
    password_digested = BCrypt::Password.create(password)

    run_sql("UPDATE staff SET name = $1, email = $2, mobile = $3, position = $4, password_digested = $5 WHERE id = $6;",[name, email, mobile, position, password_digested, id])
end

def delete_staff_by_id(id)
    run_sql("DELETE FROM staff WHERE ID = $1;", [id])
end