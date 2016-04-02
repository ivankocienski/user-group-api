class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :username
      t.string :email
      t.string :password_encrypted
      t.string :password_salt

      t.timestamps null: false
    end
  end
end
