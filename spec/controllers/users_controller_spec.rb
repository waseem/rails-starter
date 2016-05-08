require 'rails_helper'

RSpec.describe UsersController, :type => :controller do
  describe "#new" do
    it "renders user_sessions layout" do
      get :new
      expect(response).to have_http_status(200)
      expect(response).to render_template(layout: 'layouts/user_sessions')
    end
  end

  describe "#create" do
    before(:each) do
      @user = mock_model(User, auth_token: 'auth_token')
      @user_params = {
        user: { 
          email: 'hello@application.com',
          name: "User",
          password: "secret",
          password_confirmation: 'secret'
        }
      }
    end

    context "successful creation" do
      it "signs in the user" do
        expect(User).to receive(:new).with(@user_params[:user]).and_return(@user)
        expect(@user).to receive(:save).and_return(true)

        post :create, params: @user_params

        expect(response).to redirect_to(root_url)
        expect(session[:auth_token]).to eq('auth_token')
      end
    end

    context "failed creation" do
      it "renders new" do
        expect(User).to receive(:new).with(@user_params[:user]).and_return(@user)
        expect(@user).to receive(:save).and_return(false)

        post :create, params: @user_params

        expect(response).to render_template(:new, layout: "layouts/user_sessions")
      end
    end
  end
end
