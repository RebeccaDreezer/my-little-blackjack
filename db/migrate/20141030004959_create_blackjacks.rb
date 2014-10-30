class CreateBlackjacks < ActiveRecord::Migration
  def change
    create_table :blackjacks do |t|
      t.references :user, index: true
      t.text :user_hand
      t.text :dealer_hand
      t.text :deck
      t.integer :game_state
      t.timestamps
    end
  end
end
