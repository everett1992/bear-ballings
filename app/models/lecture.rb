# Defines the lecutre model.
#
# A lecture is an instance of of a course, it has one or two meeting times.
# When a lecture has one meeting its two meetings should be the same value.
class Lecture
  include Mongoid::Document
  field :s, as: :seats, type: Integer
  embedded_in :course
  embeds_one :meeting1, class_name: 'Meeting'
  embeds_one :meeting2, class_name: 'Meeting'
end
