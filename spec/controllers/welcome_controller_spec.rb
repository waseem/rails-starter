require 'rails_helper'

RSpec.describe WelcomeController, :type => :controller do
  describe "#index" do
    before(:each) do
      @user = mock_model(User)
      test_sign_in(@user)
    end

    it "renders template" do
      get :index
      expect(response).to render_template(:index)
    end
  end
end
