# ruby-todo-list
Codecademy Ruby Final Project - Command Line Todo List

#Module Menu
module Menu
    def menu
        "Welcome to the TodoList Program!
        1) Add
        2) Show
        3) Update
        4) Delete
        5) Write to file
        6) Read from file
        7) Toggle status
        Q) Quit 
"
    end

    def show
        menu
    end
end

module Promptable
    def prompt(message = "What would you like to do?", symbol = ":> ")
        print message
        print symbol
        gets.chomp
    end
end

#List Class
class List
    
    attr_reader :all_tasks

    #Create a list
    def initialize
        @all_tasks = []
    end    
    
    #Add task to list
    def add(task)
        all_tasks << task
    end

    #Show all tasks
    def show
        all_tasks.map.with_index { |l, i| "(#{i.next}): #{l}" }
    end

    #Write a list to a file
    def write_to_file(filename)
        machinified = @all_tasks.map(&:to_machine).join("\n")
        IO.write(filename, machinified)
    end

    #Read a task from a file
    def read_from_file(filename)
        IO.readlines(filename).each do |line|
            status, *description = line.split(':')
            status = status.include?('X')
            add(Task.new(description.join(':').strip, status))
        end
    end

    #Delete a task
    def delete(task_number)
        all_tasks.delete_at(task_number - 1)
    end

    #Update a task
    def update(task_number, task)
        all_tasks[task_number - 1] = task
    end

    #Toggle
    def toggle(task_number)
        all_tasks[task_number - 1].toggle_status
    end 

end

#Task Class
class Task

    attr_reader :description
    attr_accessor :completed_status
    
    #Create a task item
    
    def initialize(description, completed_status = false)
        @description = description
        @completed_status = completed_status
    end

    def to_s
        "#{represent_status} : #{description}"
    end

    def completed?
        completed_status
    end

    #Toggle status
    def toggle_status
        @completed_status = !completed?
    end

    def to_machine
        "#{represent_status}:#{description}"
    end

    private

    def represent_status
        "#{completed? ? '[X]' : '[ ]'}"
    end

end

#Program Runner
if __FILE__ == $PROGRAM_NAME
    include Menu
    include Promptable
    my_list = List.new
    puts 'Please choose from the following list:'
        until ['q'].include?(user_input = prompt(show).downcase)
        case user_input
            when '1'
                my_list.add(Task.new(prompt('What is the task you would like to accomplish?')))
            when '2'
                puts my_list.show
            when '3'
                puts my_list.show
                my_list.update(prompt('Which task would you like to update?').to_i,
                Task.new(prompt('Task Description?')))
            when '4'
                puts my_list.show
                my_list.delete(prompt('Which task to delete?').to_i)
            when '5'
                my_list.write_to_file(prompt('What is the filename to write to?'))
            when '6'
                begin
                    my_list.read_from_file(prompt('What is the filename to read from?'))
                rescue Errno::ENOENT
                    puts 'File name not found, please verify your file name and path.'
                end
            when '7'
                puts my_list.show
                my_list.toggle(prompt('Which task would you like to toggle the status for?').to_i)
            else
                puts 'Sorry, I did not understand'
            end
            prompt('Press enter to continue', '')
        end
    puts "Outro - Thanks for using the menu system!"
end 
