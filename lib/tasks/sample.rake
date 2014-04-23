namespace :sample do
  # Returns a fiber that gives the next avaliable course time.
  def time_slot_fiber
    # The combinatinos of day groupings
    # HACK: When both days are the same the class meets once per week.
    day_groups = [ [:monday, :thursday],
                   [:monday, :monday],
                   [:tuesday, :friday],
                   [:tuesday, :tuesday],
                   [:monday, :wednesday],
                   [:wednesday, :wednesday],
                   [:thursday, :thursday],
                   [:friday, :friday] ]

    # The set of times that classes meet on any day.
    times_avaliable = [ ['1000', '1120'],
                        ['1230', '1350'],
                        ['1400', '1520'],
                        ['1700', '1820'] ]

    # Map day symbols to integer values.
    day_nums = { monday:    1, tuesday:   2,
                wednesday: 3, thursday:  4 , friday:    5 }

    # Returns the next set of meeting times
    return Fiber.new do
      # Pick a random day and time combination.

      while true # The fiber must flow!
        days = day_groups[rand(day_groups.length)]
        starttime, endtime = times_avaliable[rand(times_avaliable.length)]
        Fiber.yield(days.map  do |day|
          Meeting.new({ day: day_nums[day], starttime: starttime, endtime: endtime })
        end)
      end
    end
  end

  def add_random_courses(user, courses, course_range, per_bin_range)
    #:: Randomly add courses to a users bins
    user_courses = courses.shuffle.take(rand(course_range))
    while user_courses.any?
      bin_courses = user_courses.shift(rand(per_bin_range))

      bin = user.add_course(bin_courses.shift)
      bin_courses.each { |course| bin = user.add_course(course, bin) }
    end
  end

  def set_course_times(courses)

    course_lectures = 1..4
    lecture_seats   = 15..25
    ts_fiber = time_slot_fiber

    # For each course add 1 to 4 lectures
    #   Each lecture should have two meeting times
    courses.each do |course|

      # Course has 1..4 lectures
      rand(course_lectures).times do
        m1, m2 = ts_fiber.resume
        lecture = Lecture.new(seats: rand(lecture_seats), meeting1: m1, meeting2: m2)
        course.lectures << lecture
      end
    end
  end


  def to_json(users, courses)
    # Format output as json.
    jbuilder = Jbuilder.encode do |json|

      json.courses courses do |course|
        json.id "#{course.department}#{course.number}"
        json.title course.title

        # A course has many (lectures), here called classes.
        json.classes course.lectures do |lecture|
          json.seats lecture.seats
          json.meeting1 lecture.meeting1, :day, :starttime, :endtime
          json.meeting2 lecture.meeting2, :day, :starttime, :endtime
        end
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
    num_courses       = 10
    user_course_range = 8..16
    bin_range         = 1..4
    credit_range      = 0..15

    # Select 100 courses.
    courses = Course.limit(num_courses).to_a
    courses = set_course_times(courses)

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
