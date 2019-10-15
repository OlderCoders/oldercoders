# frozen_string_literal: true

class AddDeviseToAccounts < ActiveRecord::Migration[6.0]
  def self.up
    change_table :accounts do |t|

      # Remove unused columns and indices
      t.remove_index %i[email new_email]

      t.remove :new_email
      t.remove :email_confirmation_digest
      t.remove :email_confirmation_sent_at

      t.remove :remember_digest

      t.remove :activation_digest
      t.remove :activated
      t.remove :activated_at

      t.remove :reset_digest
      t.remove :reset_sent_at

      ## Database authenticatable
      # t.string :email,              null: false, default: ""  # :email already exists in model
      # t.string :encrypted_password, null: false, default: ""  # renaming :password_digest column

      ## Recoverable
      t.string   :reset_password_token
      t.datetime :reset_password_sent_at

      ## Rememberable
      t.datetime :remember_created_at

      ## Trackable
      # t.integer  :sign_in_count, default: 0, null: false
      # t.datetime :current_sign_in_at
      # t.datetime :last_sign_in_at
      # t.inet     :current_sign_in_ip
      # t.inet     :last_sign_in_ip

      ## Confirmable
      t.string   :confirmation_token
      t.datetime :confirmed_at
      t.datetime :confirmation_sent_at
      t.string   :unconfirmed_email, length: 255

      ## Lockable
      # t.integer  :failed_attempts, default: 0, null: false # Only if lock strategy is :failed_attempts
      # t.string   :unlock_token # Only if unlock strategy is :email or :both
      # t.datetime :locked_at
    end

    rename_column :accounts, :password_digest, :encrypted_password

    add_index :accounts, :email,                unique: true
    add_index :accounts, :reset_password_token, unique: true
    add_index :accounts, :confirmation_token,   unique: true
    # add_index :accounts, :unlock_token,         unique: true
  end

  def self.down

    rename_column :accounts, :encrypted_password, :password_digest

    change_table :accounts do |t|
      # Remove Devise columns and indices
      t.remove_index :email
      t.remove_index :reset_password_token
      t.remove_index :confirmation_token

      t.remove :reset_password_token
      t.remove :reset_password_sent_at
      t.remove :remember_created_at
      t.remove :confirmation_token
      t.remove :confirmed_at
      t.remove :confirmation_sent_at
      t.remove :unconfirmed_email

      # Add back initial Account model columns
      t.string   :new_email, limit: 255, null: true, default: nil
      t.string   :email_confirmation_digest, limit: 100, null: true, default: nil
      t.datetime :email_confirmation_sent_at

      t.string   :remember_digest, limit: 100, null: true, default: nil

      t.string   :activation_digest, limit: 100, null: true, default: nil
      t.boolean  :activated, null: false, default: false
      t.datetime :activated_at

      t.string   :reset_digest, limit: 100, null: true, default: nil
      t.datetime :reset_sent_at
    end

    add_index :accounts, %i[email new_email], unique: true

  end
end
