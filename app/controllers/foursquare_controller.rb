class FoursquareController < ApplicationController
    def authenticate
        domain = request.host
        domain << (request.port == "80" ? "" : ":#{request.port}")

        redirect_to "https://foursquare.com/oauth2/authenticate?client_id=#{Foursquare::CLIENT_ID}&response_type=code&redirect_uri=http://#{domain}/foursquare/callback"
    end

    def callback
        domain = request.host
        domain << (request.port == "80" ? "" : ":#{request.port}")

        response = RestClient.get "https://foursquare.com/oauth2/access_token?client_id=#{Foursquare::CLIENT_ID}&client_secret=#{Foursquare::CLIENT_SECRET}&grant_type=authorization_code&code=#{params['code']}&redirect_uri=http://#{domain}/foursquare/callback", {content_type: :json, accept: :json}
        session["access_token"] = JSON.parse(response.body)["access_token"]

        login_user
        redirect_to root_path
    end

    def logoff
        reset_session
        redirect_to root_path
    end

    private

    def login_user
        @self = get_self
        @user = User.find_by foursquare_id: @self["id"]
        
        if @user.blank?
            @user = User.create foursquare_id: @self["id"], first_name: @self["firstName"], last_name: @self["lastName"], gender: @self["gender"], bio: @self["bio"], photo_thumb: @self["photo"]["prefix"] + "50x50" + @self["photo"]["suffix"]
        end

        session["current_user"] = @user
    end

    def get_self
        response = RestClient.get "https://api.foursquare.com/v2/users/self?oauth_token=#{session['access_token']}&v=#{Foursquare::VERSION_DATE}", {content_type: :json, accept: :json}
        JSON.parse(response.body)['response']['user']
    end
end

#131944567