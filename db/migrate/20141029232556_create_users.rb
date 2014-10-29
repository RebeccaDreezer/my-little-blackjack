class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name, null: false
      t.integer :wins, default: 0, null: false
      t.integer :losses, default: 0, null: false
      t.timestamps
    end
  end
end
