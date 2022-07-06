require 'rails_helper'

RSpec.describe "Topics", type: :request do
  describe "GET /new" do
    it "returns http success" do
      get "/topics/new"
      expect(response).to have_http_status(:success)
    end
  end

end
