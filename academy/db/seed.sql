CREATE TABLE students (
    id SERIAL PRIMARY KEY,
    name TEXT,
    email TEXT,
    password_digested TEXT,
    mobile TEXT,
    image_url TEXT,
    batch_number INTEGER,
    js_score INTEGER,
    rb_score INTEGER,
    sql_score INTEGER,
    graduated BOOLEAN
);


CREATE TABLE staff (
    id SERIAL PRIMARY KEY,
    name TEXT,
    email TEXT,
    password_digested TEXT,
    mobile TEXT,
    position TEXT
);