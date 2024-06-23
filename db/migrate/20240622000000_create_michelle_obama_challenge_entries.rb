class CreateMichelleObamaChallengeEntries < ActiveRecord::Migration[7.1]
  def change
    create_table :michelle_obama_challenge_entries do |t|
      t.integer :user_id, null: false
      t.date :date, null: false

      t.timestamps
    end

    add_index :michelle_obama_challenge_entries, %i[user_id date], unique: true
  end
end
