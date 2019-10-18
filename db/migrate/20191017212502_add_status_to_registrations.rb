class AddStatusToRegistrations < ActiveRecord::Migration[6.0]
  def change
    add_column :registrations, :status, :string, default: 'accepted'
  end
end
