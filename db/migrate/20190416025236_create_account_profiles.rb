class CreateAccountProfiles < ActiveRecord::Migration[6.0]
  def change
    create_table :account_profiles do |t|
      t.integer :account_id, null: false
      t.date :birthday
      t.boolean :display_birthday, default: true
      t.string :location, length: 128
      t.json   :latlon
      t.string :bio, limit: 255
      t.string :website_url, length: 128
      t.string :employer_name, length: 128
      t.string :employment_title, length: 128
      t.string :employer_url, length: 128
      t.string :twitter_username, length: 128
      t.string :github_username, length: 128
      t.string :facebook_url, length: 128
      t.string :linkedin_url, length: 128
      t.string :stackoverflow_url, length: 128
      t.string :dribbble_url, length: 128
      t.string :medium_url, length: 128
      t.string :behance_url, length: 128
      t.string :gitlab_url, length: 128

      t.timestamps
    end

    add_index :account_profiles, :account_id
    add_foreign_key :account_profiles, :accounts,
      column:    :account_id,
      on_update: :cascade,
      on_delete: :cascade
  end
end
