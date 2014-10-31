class AddUserStats < ActiveRecord::Migration
  def change
    create_table :user_stats do |t|
      t.references :user, index: true
      t.integer :wins, null: false, default: 0
      t.integer :losses, null: false, default: 0
      t.timestamps
    end
  end
end
