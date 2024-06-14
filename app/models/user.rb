class User < ActiveRecord::Base
  def self.from_discord_event(event)
    discord_id = event.user.id
    User.find_by(discord_id:) || User.create(discord_id:, username: event.user.name, count: 0)
  end
end