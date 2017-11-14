class HomeController < ApplicationController
  before_action :authenticate_user, except: [:index]
  before_action :set_user, except: [:index]

  def index
  end

  def wishlist
    @venues = get_recent_venues
    @wishlist = @user.venues
  end

  def add_venue
    @venue = Venue.new venue_id: venue_params[:venue_id], name: venue_params[:name], photo: get_venue_photo(venue_params[:venue_id])
    @user.venues << @venue
    @user.save

    redirect_to root_path
  end

  def remove_venue
    @user.venues.find_by(venue_id: venue_params[:venue_id]).destroy
    
    redirect_to root_path
  end


  protected

  def get_recent_venues
    recent_response = JSON.parse(RestClient.get("https://api.foursquare.com/v2/checkins/recent?oauth_token=#{session['access_token']}&v=#{Foursquare::VERSION_DATE}", {content_type: :json, accept: :json}).body)['response']['recent']
    recent_json = recent_response.map do |recent|
      photos_response = JSON.parse(RestClient.get("api.foursquare.com/v2/venues/#{recent['venue']['id']}/photos?oauth_token=#{session['access_token']}&v=#{Foursquare::VERSION_DATE}", {content_type: :json, accept: :json}).body)['response']['photos']['items']
      recent["venue"]["photo"] = photos_response.first['prefix'] + '300x400' + photos_response.first['suffix']
      recent
    end
  end

  def get_venue_photo(id)
    photos_response = JSON.parse(RestClient.get("api.foursquare.com/v2/venues/#{id}/photos?oauth_token=#{session['access_token']}&v=#{Foursquare::VERSION_DATE}", {content_type: :json, accept: :json}).body)['response']['photos']['items']
    photos_response.first['prefix'] + '300x400' + photos_response.first['suffix']
  end

  def venue_params
    params.permit(:venue_id, :name)
  end

  def set_user
    @user = User.find_by foursquare_id: current_user['foursquare_id']
  end
end
