class Meeting
  include Mongoid::Document
  field :d, as: :day, type: Integer
  field :s, as: :starttime, type: String
  field :e, as: :endtime, type: String
  embedded_in :lecture
end
