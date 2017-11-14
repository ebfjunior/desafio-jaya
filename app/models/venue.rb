class Venue
  include Mongoid::Document
  field :venue_id, type: String
  field :name, type: String
  field :photo, type: String

  embedded_in :user
end
