class Lecture
  include Mongoid::Document
  field :s, as: :seats, type: Integer
  embedded_in :course
  embeds_one :meeting1, class_name: 'Meeting'
  embeds_one :meeting2, class_name: 'Meeting'
end
