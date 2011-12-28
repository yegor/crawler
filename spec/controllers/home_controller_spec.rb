require 'spec_helper'

describe HomeController do

  describe "GET 'index'" do
    it "returns http success" do
      get 'index'
      response.should be_success
    end
  end

  describe "GET 'xml'" do
    it "returns http success" do
      get 'xml'
      response.should be_success
    end
  end

end
