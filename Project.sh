#!/bin/bash

# ===============================
# student management system(bash) by Rayyan and Abdullah
# this program helps a teacher manage student records.
# teachers can add, delete, and update students.
# students can check their grades and cgpa.
# ===============================

# file where student data is saved
data_file = "students_records.txt"

# teacher's login details
teacher_username = "Rayyan"
teacher_password = "abdullah123"

# function to calculate grade from marks
calculate_grade() {
    marks = $1
        # checking the marks and assigning a grade
        if[$marks - ge 90]; then echo "A";
    elif[$marks - ge 80]; then echo "B";
    elif[$marks - ge 70]; then echo "C";
    elif[$marks - ge 60]; then echo "D";
        else echo "F";
    fi
}

# function to convert grade to cgpa
grade_to_cgpa() {
    grade = $1
        # assigning cgpa based on grade
        case $grade in
        A) echo "4.0";;
        B) echo "3.0";;
        C) echo "2.5";;
        D) echo "1.9";;
        F) echo "1.0";;
        *) echo "0.0";;
        esac
}

# function to save student data into the file
save_student() {
    echo "$1,$2,$3,$4,$5" >> $data_file
}

# function to create the student records file if it does not exist
load_students() {
    if[!- f $data_file]; then
        touch $data_file
        fi
}

# function to add a new student
add_student() {
    echo "enter roll number: "
        read roll
        echo "enter name: "
        read name
        echo "enter marks: "
        read marks
        grade = $(calculate_grade $marks)
        cgpa = $(grade_to_cgpa $grade)
        save_student $roll "$name" $marks $grade $cgpa
        echo "student added successfully!"
}

# function to delete a student record
delete_student() {
    echo "enter roll number to delete: "
        read roll
        if grep - q "^$roll," $data_file; then
            grep - v "^$roll," $data_file > temp && mv temp $data_file
            echo "student record deleted successfully."
        else
            echo "no such student found!"
            fi
}

# function to update student marks
assign_marks() {
    echo "enter roll number to assign marks: "
        read roll
        student = $(grep "^$roll," $data_file)

        if[-z "$student"]; then
            echo "student not found!"
            return
            fi

            name = $(echo $student | cut - d',' - f2)  # get name before deleting old record
            echo "enter new marks: "
            read marks
            grade = $(calculate_grade $marks)
            cgpa = $(grade_to_cgpa $grade)

            grep - v "^$roll," $data_file > temp && mv temp $data_file
            save_student $roll "$name" $marks $grade $cgpa  # save updated data

            echo "marks updated and grades calculated."
}

# function to list students sorted by cgpa
list_students_sorted() {
    echo "1. ascending order  2. descending order"
        read choice
        if[$choice - eq 1]; then
            sort - t',' - k5 - n $data_file | column - t - s','
        else
            sort - t',' - k5 - nr $data_file | column - t - s','
            fi
}

# function to show passed students
list_passed_students() {
    echo "passed students (cgpa >= 2.0):"
        awk - F',' '$5 + 0 >= 2.0' $data_file | column - t - s','
}

# function to show failed students
list_failed_students() {
    echo "failed students (cgpa < 2.0):"
        awk - F',' '$5 + 0 < 2.0' $data_file | column - t - s','
}

# function to view a specific student's record
view_student_record() {
    echo "enter roll number: "
        read roll
        record = $(grep "^$roll," $data_file)
        if[-z "$record"]; then
            echo "no record found."
        else
            echo "$record" | column - t - s','
            fi
}

# function for student login and viewing their details
student_login() {
    echo "enter your roll number: "
        read roll
        student = $(grep "^$roll," $data_file)
        if[-z "$student"]; then
            echo "student not found!"
            return
            fi
            while true; do
                echo - e "\nstudent panel:"
                echo "1. view grades"
                echo "2. view cgpa"
                echo "3. logout"
                read ch
                case $ch in
                1) grade = $(echo $student | cut - d',' - f4); echo "your grade: $grade";;
    2) cgpa = $(echo $student | cut - d',' - f5); echo "your cgpa: $cgpa";;
    3) break;;
    *) echo "invalid choice";;
    esac
        done
}

# function for teacher login and performing tasks
teacher_login() {
    echo "enter username: "
        read uname
        echo "enter password: "
        read - s pass

        if["$uname" == "$teacher_username"] && ["$pass" == "$teacher_password"]; then
            echo - e "\nlogin successful!"
            while true; do
                echo - e "\nteacher panel:"
                echo "1. add student"
                echo "2. delete student"
                echo "3. assign marks"
                echo "4. list passed students"
                echo "5. list failed students"
                echo "6. view student record"
                echo "7. list students (sort by cgpa)"
                echo "8. logout"
                read ch
                case $ch in
                1) add_student;;
                2) delete_student;;
                3) assign_marks;;
                4) list_passed_students;;
                5) list_failed_students;;
                6) view_student_record;;
                7) list_students_sorted;;
                8) break;;
                *) echo "invalid choice";;
                esac
                    done
        else
            echo "invalid credentials!"
            fi
}

# main menu function to start the program
main_menu() {
    load_students
        while true; do
            echo - e "\n===== student management system ====="
            echo "1. teacher login"
            echo "2. student login"
            echo "3. exit"
            read choice
            case $choice in
            1) teacher_login;;
            2) student_login;;
            3) echo "exiting..."; break;;
            *) echo "invalid option, please try again.";;
            esac
                done
}

# run the main menu
main_menu
