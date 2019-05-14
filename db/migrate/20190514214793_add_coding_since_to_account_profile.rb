class AddCodingSinceToAccountProfile < ActiveRecord::Migration[6.0]
  def change
    add_column :account_profiles, :coding_since, :date, after: :display_age, null: true
  end
end
