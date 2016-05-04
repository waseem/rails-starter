class User < ApplicationRecord
  has_secure_password

  validates :password, length: { minimum: 6 }, on: :create
  validates :password, length: { minimum: 6 }, on: :update,
            if: :password_digest_changed?

  validates :email, presence: true,
                    uniqueness: { case_sensitive: false, message: 'is in use'},
                    format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i }
  validates :name, presence: true

  before_create { generate_token(:auth_token) }
  before_create { generate_token(:confirmation_token) }

  after_create :send_confirmation_email

  def confirm
    return true if confirmed?
    self.update_attribute(:confirmed, true)
  end

  def send_password_reset_email
    generate_token(:password_reset_token)
    self.save
    UserMailer.password_reset(self.id).deliver
  end

  private

  def generate_token(column)
    self[column] = unique_token_for(column)
  end

  def unique_token_for(column)
    begin
      token = SecureRandom.urlsafe_base64
    end while User.exists?(column => token)
    token
  end

  def send_confirmation_email
    UserMailer.email_confirmation(self.id).deliver
  end
end
