#Bear-Ballings:  Patrick D'Errico, Glen Oakley, Caleb Everett, Eric Palace

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
#

#Creates initial user and course data.
puts "Adding courses"
Rake::Task['courses:parse'].invoke

puts "Adding users"
name_file = File.join(Rails.root, 'lib', 'assets', 'names')

unless File.exists? name_file
  puts "#{name_file} does not exist."
  exit 1
end

unless File.readable? name_file
  puts "#{name_file} could not be read."
  exit 1
end

regex = %r{
  (?<login> .+ ){0}

  (?<name> .+ ){0}

  Login: \g<login>\s*Name: \g<name>
}x

File.open(name_file, 'r') do |f|
  f.each_line do |line|
    rr = regex.match line
    if rr
      User.create(login: rr[:login].strip, name: rr[:name].strip)
    end
  end
end

puts "#{Course.count} courses"
puts "#{User.count} users"
