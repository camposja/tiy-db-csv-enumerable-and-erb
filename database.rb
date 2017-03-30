require 'csv'
require "awesome_print"
require 'erb'

class Person
  attr_reader "name", "phone_number", "address", "position" , "salary", "slack_account", "github_account"

  def initialize(name, phone_number, address, position, salary, slack_account, github_account)
    @name = name
    @phone_number = phone_number
    @address = address
    @position = position
    @salary = salary.to_i
    @slack_account = slack_account
    @github_account = github_account
  end
end

class Database
  def initialize
    @people = []
    CSV.foreach("employees.csv", headers: true) do |row|
      name = row["name"]
      phone_number = row["phone_number"]
      address = row["address"]
      position = row["position"]
      salary = row["slack_account"]
      slack_account = row["slack_account"]
      github_account = row["github_account"]

      person = Person.new(name, phone_number, address, position, salary, slack_account, github_account)

      @people << person
    end
  end

  def add_peep
    puts "What is the new person's name? "
    name = gets.chomp
    puts "What is the person's phone number? "
    phone_number = gets.chomp
    puts "What is the person's address? "
    address = gets.chomp
    puts "What is the person's position or title? "
    position = gets.chomp
    puts "What is the person's salary? "
    salary = gets.chomp
    puts "What is the person's slack handle? "
    slack_account = gets.chomp
    puts "What is the person's GitHub user? "
    github_account = gets.chomp

    new_person = Person.new(name, phone_number, address, position, salary, slack_account, github_account)

    @people << new_person

    csv_edit
  end

  def search_peep
    puts "Input first name of the person you want to search: "
    search = gets.chomp

    found_person = @people.find { |person| person.name == search }

    if found_person
      puts "The employee's name is #{found_person.name}"
      puts "The employee's phone is #{found_person.phone_number}"
      puts "The employee's address is #{found_person.address}"
      puts "The employee's position is #{found_person.position}"
      puts "The employee's salary is #{found_person.salary}"
      puts "The employee's Slack handle is #{found_person.slack_account}"
      puts "The employee's GitHub user is #{found_person.github_account}"
    else
      puts "The person does not exist in TIY"
    end
  end

  def delete_peep
    print "Type first name of the person you want to delete: "
    delete = gets.chomp

    delete_person = @people.find { |person| person.name == delete }
    index = 0
    finder = false
    if delete_person
      finder = true
      @people.slice!(index)
      puts "#{delete} has been deleted."
      csv_edit
    end
    index += 1
    if finder == false
      puts "The person is not in TIY"
      puts "thank you for chosing TIY, good bye!"
    end
  end

  def csv_edit
    CSV.open("employees.csv", "w") do |csv|
      csv << ["name", "phone_number", "address", "position", "salary", "slack_account", "github_account"]
      @people.each do |new_person|
        csv << [new_person.name, new_person.phone_number, new_person.address, new_person.position, new_person.salary, new_person.slack_account, new_person.github_account]
      end
    end
  end

  def report
    puts "REPORT SUMMARY"
    puts "The total total instructor salary is #{instructor_salary}"
    puts "The total director salary is #{director_salary}"
    puts "The total instructor count is #{instructor_count}"
    puts "The total student count is #{student_count}"
    puts " "
      @people.each do |person|
        puts "REPORT HEADCOUNT"
        puts "The employee's name is #{person.name}"
        puts "The employee's phone is #{person.phone_number}"
        puts "The employee's address is #{person.address}"
        puts "The employee's position is #{person.position}"
        puts "The employee's salary is #{person.salary}"
        puts "The employee's Slack handle is #{person.slack_account}"
        puts "The employee's GitHub user is #{person.github_account}"
        puts " "
      end
  end

  def instructor_salary
    @people.select { |person| person.position.include?("instructor")}.map { |person| person.salary.to_i }.sum
  end

  def director_salary
    @people.select { |person| person.position.include?("campus director")}.map { |person| person.salary.to_i }.sum
  end

  def instructor_count
    @people.select { |person| person.position.include?("instructor")}.count
  end

  def student_count
    @people.select { |person| person.position.include?("student")}.count
  end

  def employee_report
    employee_profile = @people.sort_by { |person| person.name }
    employee_profile.each do |person|
    ap employee_profile
    end
  end

  def employee_report_html
    html_string = File.read("report.html.erb")
    erb_db = ERB.new(html_string)
    html = erb_db.result(binding)

    File.write("report.html", html)
  end

end


database = Database.new

loop do
  puts "Add a person (a), Search for a person (s), Delete a person (d) or Print a report (r) or generate HTML (h)"
  selection = gets.chomp
  database.add_peep if selection == "a"
  database.delete_peep if selection == "d"
  database.search_peep if selection == "s"
  database.report if selection == "r"
  database.employee_report_html if selection == "h"
end
# name,phone,address,position,salary,slack,github
# Gavin,555-1212,1 Main Street,Instructor,1000000,gstark,gstark
# Jason,555-4242,500 Elm Street,Instructor,2000000,ambethia,ambethia
# Toni,555-4444,200 Pine Street,Campus Director,3000000,amazing_toni,amazing_toni
