class Course
  #:: Fields
  include Mongoid::Document
  field :d, as: :department, type: String
  field :n, as: :number,     type: Integer
  field :t, as: :title,      type: String

  #:: Validations
  validates_presence_of :department, :number, :title
  validates_uniqueness_of :number, scope: :department
  validates_numericality_of :number, greater_than: 0, only_integer: true
end
