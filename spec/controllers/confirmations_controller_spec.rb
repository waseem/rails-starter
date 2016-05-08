require 'rails_helper'

RSpec.describe ConfirmationsController, :type => :controller do
  describe "#new" do
    before(:each) do
      @user = mock_model(User, confirmation_token: 'token', auth_token: 'auth_token')
    end

    context "user is found with confirmation token" do
      before(:each) do
        expect(User).to receive(:find_by_confirmation_token).with(@user.confirmation_token).and_return(@user)
      end

      context "user is unconfirmed" do
        it "confirms and signs in the user" do
          expect(@user).to receive(:confirmed?).with(no_args).and_return(false)
          expect(@user).to receive(:confirm).with(no_args).and_return(true)

          get :new, params: { confirmation_token: @user.confirmation_token }

          expect(response).to              redirect_to(root_url)
          expect(flash[:notice]).to        eq("You have successfully confirmed your email.")
          expect(session[:auth_token]).to  eq('auth_token')
        end
      end

      context "user is already confirmed" do
        it "redirects the user to root url" do
          expect(@user).to receive(:confirmed?).with(no_args).and_return(true)

          get :new, params: { confirmation_token: @user.confirmation_token }

          expect(response).to              redirect_to(root_url)
          expect(flash[:notice]).to        eq(nil)
          expect(session[:auth_token]).to  eq(nil)
        end
      end
    end

    context "user is with confirmation token does not exist" do
      it "renders proper error message" do
        expect(User).to receive(:find_by_confirmation_token).with(@user.confirmation_token).and_return(nil)

        get :new, params: { confirmation_token: @user.confirmation_token }

        expect(response).to       redirect_to(root_url)
        expect(flash[:alert]).to eq("We do not have record of this email.")
      end
    end
  end
end
