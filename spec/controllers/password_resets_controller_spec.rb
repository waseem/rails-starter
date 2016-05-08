require 'rails_helper'

RSpec.describe PasswordResetsController, :type => :controller do
  before(:each) do
    @user = mock_model(User, email: "hello@application.com", password_reset_token: 'reset-token')
  end

  describe "#new" do
    it "renders new template" do
      get :new

      expect(response).to render_template(:new)
    end
  end

  describe "#create" do
    context "finds the user with email" do
      it "sends user a password reset email" do
        expect(User).to receive(:find_by_email).with(@user.email).and_return(@user)
        expect(@user).to receive(:send_password_reset_email).with(no_args).and_return(true)

        post :create, params: { email: @user.email }

        expect(response).to redirect_to(new_password_reset_url)
        expect(flash[:notice]).to eq("We have sent a password reset email to that email address.")
      end
    end

    context "does not find the user with email" do
      it "does not send password reset email" do
        expect(User).to receive(:find_by_email).with(@user.email).and_return(nil)

        post :create, params: { email: @user.email }

        expect(response).to redirect_to(new_password_reset_url)
        expect(flash[:notice]).to eq("We have sent a password reset email to that email address.")
      end
    end
  end

  describe "#edit" do
    it "renders new template" do
      expect(User).to receive(:find_by_password_reset_token!).with(@user.password_reset_token).and_return(@user)

      get :edit, params: { id: @user.password_reset_token }

      expect(response).to render_template(:edit)
    end
  end

  describe "#update" do
    before(:each) do
      expect(User).to receive(:find_by_password_reset_token!).with(@user.password_reset_token).and_return(@user)
    end

    context "password param is blank" do
      it "shows error message" do
        patch :update, params: { id: @user.password_reset_token, user: { password: "", password_confirmation: 'secret' }}

        expect(response).to redirect_to(edit_password_reset_url(@user.password_reset_token))
        expect(flash[:alert]).to eq("Can not accept blank password")
      end
    end

    context "password confirmation param is blank" do
      it "shows error message" do
        patch :update, params: { id: @user.password_reset_token, user: { password: "secret", password_confirmation: '' }}

        expect(response).to redirect_to(edit_password_reset_url(@user.password_reset_token))
        expect(flash[:alert]).to eq("Can not accept blank password")
      end
    end

    context "password update" do
      it "is successful" do
        expect(@user).to receive(:update_attributes).with(password: 'secret', password_confirmation: 'secret').and_return(true)
        expect(@user).to receive(:update_attribute).with(:password_reset_token, nil).and_return(true)

        patch :update, params: { id: @user.password_reset_token, user: { password: 'secret', password_confirmation: 'secret' }}

        expect(response).to redirect_to(root_url)
        expect(flash[:notice]).to eq("Password has been reset!")
      end

      it "is unsuccessful" do
        expect(@user).to receive(:update_attributes).with(password: 'secret', password_confirmation: 'secret').and_return(false)

        patch :update, params: { id: @user.password_reset_token, user: { password: 'secret', password_confirmation: 'secret' }}

        expect(response).to render_template(:edit)
        expect(flash[:notice]).to eq("There was some error updating your password. Please try again later.")
      end
    end
  end
end
