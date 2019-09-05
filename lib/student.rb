class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
    # create a new Student object given a row from the database
    new_student = self.new  # self.new is the same as running Song.new
    new_student.id = row[0]
    new_student.name =  row[1]
    new_student.grade = row[2]
    new_student  # return the newly created instance


  end

  def self.all
    #boiler plate
    # retrieve all the rows from the "Students" database
    # remember each row should be a new instance of the Student class
    # remember to use DB to connect your self.all method to the remainder.

     sql = <<-SQL
     SELECT * FROM students
     SQL
     DB[:conn].execute(sql).map() { | row | self.new_from_db(row) }
    
  end

  #iterate over the student array and .grade to year in string.
    
    def self.all_students_in_grade_9
      self.all.select() { | student | student.grade == "9" }
    
    end
    
    #iterate over the student array and .grade and string into integer < 12. 
    
    def self.students_below_12th_grade()
    
    self.all.select() { | student | student.grade.to_i() < 12 }
    
  end

    #iterate over the student array and .grade and string to integer the include [0..x]
   
    def self.all_students_in_grade_X(x)
      self.all().select() { | student | student.grade.to_i() == x }
    end
    
    #select all and match the student to 0 to x number 
    
    def self.first_X_students_in_grade_10(x)
      self.all().select() { | student | student.grade.to_i() == 10}[0...x]
    end
    
    #select all and match the student to and return the first numebr give [0]

    def self.first_student_in_grade_10()
      self.all.select{|student|student.grade.to_i() == 10}[0]
    end

    def self.all_students_in_grade_X(x)
      self.all().select() { | student | student.grade.to_i() == x }
    end
    
    
  
  def self.find_by_name(name)
    # find the student in the database given a name
    # return a new instance of the Student class
    
    sql = <<-SQL
    SELECT * FROM students
    WHERE name = ?
    LIMIT 1
    SQL


    DB[:conn].execute(sql, name).map do |row|
    self.new_from_db(row)
  end.first
 
end
  

  def save
    sql = <<-SQL
      INSERT INTO students (name, grade) 
      VALUES (?, ?)
    SQL

    DB[:conn].execute(sql, self.name, self.grade)
  end
  
  def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS students (
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade TEXT
    )
    SQL

    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = "DROP TABLE IF EXISTS students"
    DB[:conn].execute(sql)
  end

end
