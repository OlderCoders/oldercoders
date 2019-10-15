class DropStiColumnFromAccounts < ActiveRecord::Migration[6.0]
  def change
    remove_column :accounts, :type, :string, limit: 255
  end
end
