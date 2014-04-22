namespace :sample do
  def add_random_courses(user, courses, course_range, per_bin_range)
    #:: Randomly add courses to a users bins
    user_courses = courses.shuffle.take(rand(course_range))
    while user_courses.any?
      bin_courses = user_courses.shift(rand(per_bin_range))

      bin = user.add_course(bin_courses.shift)
      bin_courses.each { |course| bin = user.add_course(course, bin) }
    end
  end

  def to_json(users, courses)
    # Format output as json.
    jbuilder = Jbuilder.encode do |json|

      json.courses courses do |course|
        json.id "#{course.department}#{course.number}"
        json.title course.title
      end

      json.users users do |user|
        json.id user.id.to_s
        json.credits user.credits
        json.bins user.bins do |bin|
          json.priority user.bins.index(bin)
          json.courses bin.courses do |course|
            json.array! "#{course.department}#{course.number}"
          end
        end
      end
    end
    JSON.pretty_generate(JSON.parse(jbuilder))
  end

  desc "Output list of fake data to a file"
  task :selections => :environment do
    num_users         = 30
    num_courses       = 100
    user_course_range = 8..16
    bin_range         = 1..4
    credit_range      = 0..24

    # Select 100 courses.
    courses = Course.limit(num_courses).to_a

    # Create 30 users.
    users = num_users.times.map do |x|
      User.create(name: "user_#{x}", credits: rand(credit_range))
    end

    # Add 8 to 16 courses in bins of 1 to 4 to each user.
    users.each do |user|
      add_random_courses(user, courses, user_course_range, bin_range)
    end

    # Generate json.
    output = to_json(users, courses)

    bins = users.map(&:bins).flatten
    user_courses = users.map(&:bins).flatten.map(&:courses).flatten

    avg_courses = user_courses.count / users.count
    avg_bins = bins.count / users.count
    course_avg_bins = bins.count / courses.count

    most_popular = user_courses.group_by { |uc| "#{uc.department}#{uc.number}" }.values.sort_by(&:count).last.count

    puts "There are #{users.count} users"
    puts "each user has an average of #{avg_courses} courses."
    puts "each user has an average of #{avg_bins} bins."


    puts

    puts "There are #{courses.count} courses"
    puts "The avarage course is in #{course_avg_bins} bins"
    puts "The most popular course is in #{most_popular} bins"

    # Write the file to /lib/assets/sample.txt'.
    output_filename = File.join Rails.root, 'lib', 'assets', 'sample.txt'
    File.open(output_filename, 'w') do |f|
      output.lines.each { |line| f.write line }
    end
  end
end
