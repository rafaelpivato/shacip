class CreateRegistrations < ActiveRecord::Migration[6.0]
  def change
    create_table :registrations do |t|
      t.references :account, null: true, foreign_key: true
      t.references :user, null: true, foreign_key: true
      t.string :email
      t.string :password_digest
      t.string :params
      t.string :confirmed

      t.timestamps
    end
  end
end
