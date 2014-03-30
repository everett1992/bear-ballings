namespace :courses do
  desc "Gets courses from file"
  task :parse => :environment do
    input_file = 'lib/assets/courses.txt'
    output_file = 'lib/assets/invalid_courses.txt'
    regex = %r{
      (?<department> .+ ){0}

      (?<number> .+ ){0}

      (?<title> .+ ){0}

      \(['"]\g<department>['"],\s+['"]\g<number>['"],\s+['"]\g<title>['"]\)
    }x

    #:: validate existance and readability of the input file
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
      f.each_line do |line|
        rr = regex.match line
        attrs = %i{department number title}
        course_hash = if rr
          Hash[attrs.map { |key| [key, rr[key]] }]
        else
          Hash[attrs.zip(Array.new(attrs.length, nil))]
        end

        course = Course.create course_hash
        unless course.valid?
          invalid_lines << "#{line.chomp}: #{course.errors.full_messages.join(', ')}\n"
        end
      end
    end

    File.open(output_file, 'w') do |f|
      invalid_lines.each do |line|
        f.write line
      end
    end
    puts "There are now #{Course.count} courses"
    puts "#{invalid_lines.count} invalid lines writen to #{output_file}"
  end
end
