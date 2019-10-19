class RenameRelationshipsTable < ActiveRecord::Migration[6.0]
  def change
    rename_table :relationships, :account_relationships
  end
end
