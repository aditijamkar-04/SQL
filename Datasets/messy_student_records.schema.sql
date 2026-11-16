-- Messy Student Records
--
-- Student, enrollment, grade and contact records merged from three schools' systems, with the formats, typos and duplicates that merge left behind.
--
-- Run this from the directory holding the data files:
--   duckdb -c ".read messy_student_records.schema.sql"

CREATE TABLE schools (
  school_id INTEGER NOT NULL,
  school_name VARCHAR NOT NULL,
  source_system VARCHAR NOT NULL,
  PRIMARY KEY (school_id)
);

CREATE TABLE courses (
  course_id INTEGER NOT NULL,
  course_code VARCHAR NOT NULL,
  course_name VARCHAR NOT NULL,
  department VARCHAR NOT NULL,
  credits DECIMAL(12,2) NOT NULL,
  PRIMARY KEY (course_id)
);

CREATE TABLE students (
  student_id INTEGER NOT NULL,
  school_id INTEGER NOT NULL,
  first_name VARCHAR NOT NULL,
  last_name VARCHAR NOT NULL,
  email VARCHAR,
  birth_date VARCHAR,
  grade_level VARCHAR NOT NULL,
  PRIMARY KEY (student_id),
  FOREIGN KEY (school_id) REFERENCES schools (school_id)
);

CREATE TABLE contacts (
  contact_id INTEGER NOT NULL,
  student_id INTEGER NOT NULL,
  contact_name VARCHAR NOT NULL,
  relationship VARCHAR NOT NULL,
  phone VARCHAR,
  PRIMARY KEY (contact_id),
  FOREIGN KEY (student_id) REFERENCES students (student_id)
);

CREATE TABLE enrollments (
  import_row INTEGER NOT NULL,
  school_id INTEGER NOT NULL,
  student_id INTEGER NOT NULL,
  course_code VARCHAR NOT NULL,
  term VARCHAR NOT NULL,
  enrolled_on VARCHAR,
  status VARCHAR NOT NULL,
  PRIMARY KEY (import_row),
  FOREIGN KEY (school_id) REFERENCES schools (school_id)
  -- student_id references students.student_id (not declared:
  -- some rows point at a students row that does not exist)
);

CREATE TABLE grades (
  import_row INTEGER NOT NULL,
  school_id INTEGER NOT NULL,
  student_id INTEGER NOT NULL,
  course_code VARCHAR NOT NULL,
  term VARCHAR NOT NULL,
  score VARCHAR,
  letter_grade VARCHAR,
  PRIMARY KEY (import_row),
  FOREIGN KEY (school_id) REFERENCES schools (school_id)
  -- student_id references students.student_id (not declared:
  -- some rows point at a students row that does not exist)
);

COPY schools FROM 'schools.csv' (FORMAT CSV, HEADER);
COPY courses FROM 'courses.csv' (FORMAT CSV, HEADER);
COPY students FROM 'students.csv' (FORMAT CSV, HEADER);
COPY contacts FROM 'contacts.csv' (FORMAT CSV, HEADER);
COPY enrollments FROM 'enrollments.csv' (FORMAT CSV, HEADER);
COPY grades FROM 'grades.csv' (FORMAT CSV, HEADER);
