require 'rails_helper'

RSpec.describe User, :type => :model do
  before(:each) do
    @user = User.new(name: "User", email: "hello@application.com", password: 'secret', password_confirmation: 'secret')
  end

  describe "creation" do
    it 'generates tokens' do
      @user.save!
      expect(@user.auth_token).to         be_present
      expect(@user.confirmation_token).to be_present
    end
  end

  describe "#confirm" do
    context "user is already confirmed" do
      it "returns true" do
        @user.save
        @user.update_attribute(:confirmed, true)
        expect(@user.confirm).to eq(true)
      end
    end

    context "user is unconfirmed" do
      it "confirms the user" do
        @user.save
        expect(@user.confirmed?).to eq(false)
        @user.confirm
        expect(@user.confirmed?).to eq(true)
      end
    end
  end

  describe "#send_password_reset_email" do
    it "sends password reset email" do
      mail = double
      @user.save
      expect(@user.password_reset_token).to_not be_present
      expect(UserMailer).to receive(:password_reset).with(@user.id).and_return(mail)
      expect(mail).to receive(:deliver).with(any_args)
      @user.send_password_reset_email
      expect(@user.password_reset_token).to be_present
    end
  end
end
