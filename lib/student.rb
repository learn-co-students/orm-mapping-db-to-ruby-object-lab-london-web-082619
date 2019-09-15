require 'pry'

class Student
  attr_accessor :id, :name, :grade

  def save
    sql = <<-SQL
      INSERT INTO students (name, grade) 
      VALUES (?, ?);
    SQL

    DB[:conn].execute(sql, self.name, self.grade)
  end
  
  def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS students (
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade TEXT
    );
    SQL

    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = "DROP TABLE IF EXISTS students;"
    DB[:conn].execute(sql)
  end

  def self.new_from_db(row)
    student = self.new
    student.id = row[0]
    student.name = row[1]
    student.grade = row[2]
    student
  end

  def self.find_by_name(name)
    sql = <<-SQL
      SELECT * FROM students
      WHERE name = ?
      LIMIT 1;
    SQL
    row = DB[:conn].execute(sql, name)[0]

    new_from_db(row)
  end

  def self.mapper(rows)
    rows.map { |row| new_from_db(row) }
  end

  def self.all
    student_rows = DB[:conn].execute("SELECT * FROM students;")
    mapper(student_rows)
  end

  def self.all_students_in_grade_9
    sql = "SELECT * FROM students WHERE grade = 9;"
    student_rows = DB[:conn].execute(sql)
    mapper(student_rows)
  end

  def self.students_below_12th_grade
    sql = "SELECT * FROM students WHERE grade < 12;"
    student_rows = DB[:conn].execute(sql)
    mapper(student_rows)
  end

  def self.first_X_students_in_grade_10(x)
    sql = "SELECT * FROM students WHERE grade = 10 LIMIT ?;"
    student_rows = DB[:conn].execute(sql, x)
    mapper(student_rows)
  end

  def self.first_student_in_grade_10
    first_X_students_in_grade_10(1).first
  end

  def self.all_students_in_grade_X(x)
    sql = "SELECT * FROM students WHERE grade = ?;"
    student_rows = DB[:conn].execute(sql, x)
    mapper(student_rows)
  end

end
