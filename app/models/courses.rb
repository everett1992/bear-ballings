class Courses
  include Mongoid::Document
  field :department, type: String
  field :number,     type: Integer
  field :title,      type: String
end
