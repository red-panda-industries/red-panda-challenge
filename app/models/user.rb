class User < ActiveRecord::Base
  has_many :michelle_obama_challenge_entries

  validates :discord_id, presence: true, uniqueness: true
  validates :username, presence: true
  validates :count, presence: true, numericality: { greater_than_or_equal_to: 0 }

  def complete_michelle_obama_challenge_for_today!
    michelle_obama_challenge_entries.create!(date: Date.today)
  end

  def has_completed_michelle_obama_challenge_today?
    michelle_obama_challenge_entries.exists?(date: Date.today)
  end

  def current_michelle_obama_challenge_streak
    michelle_obama_challenge_streaks
      .find { |streak| streak.first.date == Date.today }
  end

  def longest_michelle_obama_challenge_streak
    michelle_obama_challenge_streaks
      .max_by(&:size)
  end

  def michelle_obama_challenge_streaks
    cached_michelle_obama_challenge_entries
      .chunk_while { |entry, previous_entry| entry.date == previous_entry.date + 1 }
  end

  def cached_michelle_obama_challenge_entries
    @cached_michelle_obama_challenge_entries ||=
      michelle_obama_challenge_entries.order(date: :desc).to_a
  end

  def reload
    @cached_michelle_obama_challenge_entries = nil
    super
  end

  # Factory method to create or find a User from a Discord event
  def self.from_discord_event(event)
    find_or_create_by(discord_id: event.user.id) do |user|
      user.username = event.user.name
      user.count = 0
    end
  end
end
