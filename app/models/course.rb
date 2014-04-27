# Defines the course model.
# A course is a topic offered by the school.
class Course
  #:: Fields
  include Mongoid::Document
  field :d, as: :department, type: String
  field :n, as: :number,     type: Integer
  field :t, as: :title,      type: String
  field :_id, type: String, default: -> { "#{department}#{number}" }

  embeds_many :lectures

  #:: Validations
  validates_presence_of :department, :number, :title
  validates_uniqueness_of :number, scope: :department
  validates_numericality_of :number, greater_than: 0, only_integer: true

  def to_s
    "#{_id}"
  end
end
