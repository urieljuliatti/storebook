require 'rails_helper'

RSpec.describe "/login", type: :request do

  let(:user_params) {
    {:email => "admin@email.com", :password => "123456"}
  }

  describe "POST /login" do
    before(:each) do
      @user = User.new user_params
    end

    it "renders a successful response" do
      headers = { "ACCEPT" => "application/json" }

      user = User.create! user_params
      post "/login", :params => {:email => @user.email, :password => @user.password }, :headers => headers
      expect(response.content_type).to eq("application/json; charset=utf-8")
      expect(JSON.parse(response.body)['token']).to_not be_nil
      expect(response).to have_http_status(:ok)
    end
    it "renders an error response" do
      headers = { "ACCEPT" => "application/json" }

      post "/login", :params => {:email => @user.email, :password => "123" }, :headers => headers
      expect(response.content_type).to eq("application/json; charset=utf-8")
      expect(JSON.parse(response.body)['token']).to be_nil
      expect(response).to have_http_status(:unauthorized)
    end
  end
end
