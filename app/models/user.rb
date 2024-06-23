class User < ActiveRecord::Base
  has_many :michelle_obama_challenge_entries

  validates :discord_id, presence: true, uniqueness: true
  validates :username, presence: true
  validates :count, presence: true, numericality: { greater_than_or_equal_to: 0 }

  def has_completed_michelle_obama_challenge_today?
    michelle_obama_challenge_entries.where(date: Date.today).exists?
  end

  def complete_michelle_obama_challenge!
    michelle_obama_challenge_entries.create!(date: Date.today)
  end

  # @param [Discordrb::Events::MessageEvent] event
  # @return [User]
  def self.from_discord_event(event)
    discord_id = event.user.id
    User.find_by(discord_id:) || User.create(discord_id:, username: event.user.name, count: 0)
  end
end