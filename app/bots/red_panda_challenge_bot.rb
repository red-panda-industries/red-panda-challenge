class RedPandaChallengeBot < ApplicationBot
  include RedPandaChallengeBotHelper
  include SoundsHelper
  
  COMMAND_HANDLERS = {
    user:     :handle_user_command!,
    count:    :handle_count_command!,
    michelle: :handle_michelle_command!,
  }

  INTENTS = %i(
    server_messages
    server_message_reactions
    voice_states
  )

  def handle_user_command!(event)
    user = User.from_discord_event(event)

    event << "Your username is #{user.username} and your Discord ID is #{user.discord_id}."
    event << "Your count is #{user.count}. Your created at is #{user.created_at}. Your updated at is #{user.updated_at}."
  end

  def handle_count_command!(event)
    user = User.from_discord_event(event)

    user.count += 1
    user.save!

    event << "You have used this command #{user.count} times now."
  end

  def handle_michelle_command!(event)
    user = User.from_discord_event(event)

    if user.has_completed_michelle_obama_challenge_today?
      event << 'You have already completed the Michelle Obama challenge today.'
    else
      user.complete_michelle_obama_challenge_for_today!
      event << 'You have completed the Michelle Obama challenge for today!'
    end

    display_michelle_obama_challenge_stats!(user:, event:)
    event << 'Keep up the good work! - Michelle Obama'

    play_wow_ethan_sound!(event)
  end
end
