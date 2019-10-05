class AllowNullAccountNames < ActiveRecord::Migration[6.0]
  def change
    change_column_null :accounts, :first_name, true
    change_column_null :accounts, :last_name, true
  end
end
