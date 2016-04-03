class CreateUserAuthTokens < ActiveRecord::Migration
  def change
    create_table :user_auth_tokens do |t|
      t.integer :user_id
      t.string  :token

      t.timestamps null: false
    end

    add_index :user_auth_tokens, :token, unique: true
  end
end
