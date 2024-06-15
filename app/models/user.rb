class User < ActiveRecord::Base
  # @param [Discordrb::Events::MessageEvent] event
  # @return [User]
  def self.from_discord_event(event)
    discord_id = event.user.id
    User.find_by(discord_id:) || User.create(discord_id:, username: event.user.name, count: 0)
  end
end