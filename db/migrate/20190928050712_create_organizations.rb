class CreateOrganizations < ActiveRecord::Migration[6.0]
  def change
    create_table :organizations do |t|
      t.string :name
      t.string :number

      t.timestamps
    end
    add_index :organizations, :number, unique: true
  end
end
