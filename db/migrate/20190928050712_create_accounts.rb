class CreateAccounts < ActiveRecord::Migration[6.0]
  def change
    create_table :accounts do |t|
      t.string :name
      t.string :number

      t.timestamps
    end
    add_index :accounts, :number, unique: true
  end
end
