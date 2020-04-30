def logged_in?
    !!session["user_id"]
end

def list_active_batches(students)
    active_batches = []
    students.each do |student|
        active_batches << student["batch_number"].to_i
    end
    active_batches.sort.uniq!
end