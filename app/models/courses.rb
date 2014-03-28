class Courses
  #:: Fields
  include Mongoid::Document
  field :department, type: String
  field :number,     type: Integer
  field :title,      type: String

  #:: Validations
  validates_presence_of :department, :number, :title
  validates_uniqueness_of :number, scope: :department
  validates_numericality_of :number, greater_than: 0, only_integer: true
end
