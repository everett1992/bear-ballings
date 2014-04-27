# Defines the meeting model.
# A meeting is a distinct time that a lecture meets each week.

class Meeting
  include Mongoid::Document
  field :d, as: :day, type: Integer
  field :s, as: :starttime, type: String
  field :e, as: :endtime, type: String
  embedded_in :lecture
end
