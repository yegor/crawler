require 'spec_helper'

describe AutocompleteController do

  describe "GET 'game'" do
    it "returns http success" do
      get 'game'
      response.should be_success
    end
  end

  describe "GET 'publisher'" do
    it "returns http success" do
      get 'publisher'
      response.should be_success
    end
  end

end
