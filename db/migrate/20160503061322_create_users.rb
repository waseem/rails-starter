class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.string :email, null: false
      t.string :name,  null: false

      t.boolean :confirmed, default: false
      t.string  :confirmation_token

      t.string :password_reset_token
      t.string :password_digest
      t.string :auth_token, null: false

      t.index :email,      unique: true
      t.index :auth_token, unique: true
      t.timestamps
    end
  end
end
