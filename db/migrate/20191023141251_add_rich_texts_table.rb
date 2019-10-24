class AddRichTextsTable < ActiveRecord::Migration[6.0]
  def change
    create_table :rich_texts do |t|
      t.references :record, null: false, polymorphic: true, index: false
      t.text       :body_raw, size: :long
      t.text       :body, size: :long

      t.timestamps

      t.index [ :record_type, :record_id ], name: "index_rich_texts_uniqueness", unique: true
    end
  end
end
