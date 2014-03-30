class User
  include Mongoid::Document
  field :n, as: :name, type: String
end
