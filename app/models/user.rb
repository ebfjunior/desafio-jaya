class User
  include Mongoid::Document
  field :foursquare_id, type: Integer
  field :first_name, type: String
  field :last_name, type: String
  field :photo_thumb, type: String
  field :gender, type: String
  field :bio, type: String

  embeds_many :venues
end
