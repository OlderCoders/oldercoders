class ChangeDisplayBirthdayToDisplayAgeOnAccountProfiles < ActiveRecord::Migration[6.0]
  def change
    rename_column :account_profiles, :display_birthday, :display_age
  end
end
