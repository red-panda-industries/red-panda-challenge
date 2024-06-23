class User < ActiveRecord::Base
  has_many :michelle_obama_challenge_entries

  validates :discord_id, presence: true, uniqueness: true
  validates :username, presence: true
  validates :count, presence: true, numericality: { greater_than_or_equal_to: 0 }

  def has_completed_michelle_obama_challenge_today?
    MichelleObamaChallengeEntry.exists?(user: self, date: Date.today)
  end

  def complete_michelle_obama_challenge_for_today!
    MichelleObamaChallengeEntry.create!(user: self, date: Date.today)
  end

  # @param [Discordrb::Events::MessageEvent] event
  # @return [User]
  def self.from_discord_event(event)
    discord_id = event.user.id
    User.find_by(discord_id:) || User.create(discord_id:, username: event.user.name, count: 0)
  end
end