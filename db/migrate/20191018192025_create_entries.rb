class CreateEntries < ActiveRecord::Migration[6.0]
  def change
    create_table :entries do |t|
      t.bigint :account_id, null: false
      t.string :type, null: false
      t.string :title, null: false
      t.string :slug
      t.integer :comment_count, default: 0
      t.integer :vote_total, default: 0

      t.timestamps
    end
    add_index :entries, :slug, unique: true
    add_index :entries, :vote_total
  end
end
