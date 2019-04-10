class CreateAccounts < ActiveRecord::Migration[6.0]
  def change
    create_table :accounts do |t|
      t.string   :type, limit: 255
      t.integer  :role, default: 0, null: false
      t.string   :first_name, limit: 255, null: false
      t.string   :last_name, limit: 255, null: false
      t.string   :username, limit: 100
      t.string   :email, limit: 255
      t.string   :new_email, limit: 255, null: true, default: nil
      t.string   :email_confirmation_digest, limit: 100, null: true, default: nil
      t.datetime :email_confirmation_sent_at
      t.string   :password_digest, limit: 100, null: true, default: nil
      t.string   :remember_digest, limit: 100, null: true, default: nil
      t.string   :activation_digest, limit: 100, null: true, default: nil
      t.boolean  :activated, null: false, default: false
      t.datetime :activated_at
      t.string   :reset_digest, limit: 100, null: true, default: nil
      t.datetime :reset_sent_at
      t.string   :time_zone, limit: 255, default: 'UTC'

      t.timestamps
    end

    add_index :accounts, :username, unique: true
    add_index :accounts, :role
    add_index :accounts, %i[email new_email], unique: true

  end
end
