class CreateUsers < ActiveRecord::Migration[7.1]
    def change
      create_table :users do |t|
        t.integer :discord_id, null: false
        t.string :username, null: false
        t.integer :count, null: false, default: 0
  
        t.timestamps
      end
  
      add_index :users, :discord_id, unique: true
    end
  end
  