ENV["RAILS_ENV"] ||= "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

puts "Checking test environment..."
puts "#{Course.count} courses"

if Course.count == 0
  puts "No Courses found, seeding test database"
  Rake::Task['db:seed'].invoke
end
if User.count == 0
  puts "No Users found, seeding test database"
  Rake::Task['db:seed'].invoke
end

class ActiveSupport::TestCase
  # Add more helper methods to be used by all tests here...
end
