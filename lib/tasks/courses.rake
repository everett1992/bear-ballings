namespace :courses do
  desc "Gets courses from file"
  task :parse => :environment do
    input_file = 'lib/assets/courses.txt'
    output_file = 'lib/assets/invalid_courses.txt'

    unless File.exists? input_file
      puts "#{input_file} does not exist."
      exit 1
    end

    unless File.readable? input_file
      puts "#{input_file} could not be read."
      exit 1
    end


    # Array of invalid lines
    invalid_lines = Array.new

    File.open(input_file, 'r') do |f|

      regex = %r{
        (?<department> .+ ){0}

        (?<number> [0-9]+ ){0}

        (?<title> .+ ){0}

        \(['"]\g<department>['"],\s+['"]\g<number>['"],\s+['"]\g<title>['"]\)
      }x

      f.each_line do |line|


        rr = regex.match line

        if rr
          attrs = [:department, :number, :title]
          course_hash = Hash[attrs.map { |key| [key, rr[key]] }]
          Courses.create course_hash
        else
          invalid_lines << line
        end
      end
    end

    File.open(output_file, 'w') do |f|
      invalid_lines.each do |line|
        f.write line
      end
    end
    puts "There are now #{Courses.count} courses"
    puts "#{invalid_lines.count} invalid lines writen to #{output_file}"
  end
end
