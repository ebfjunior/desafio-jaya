class HomeController < ApplicationController
  def index
    if user_logged_in?
        response = RestClient.get "https://api.foursquare.com/v2/checkins/recent?oauth_token=#{session['access_token']}&v=#{Foursquare::VERSION_DATE}", {content_type: :json, accept: :json}

        @venues = JSON.parse(response.body)['response']['recent']
    end
  end
end
