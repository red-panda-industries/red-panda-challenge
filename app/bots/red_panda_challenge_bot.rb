class RedPandaChallengeBot < ApplicationBot
  COMMAND_HANDLERS = {
    :user     => :handle_user_info!,
    :count    => :handle_count!,
    :michelle => :handle_michelle!,
  }

  def handle_user_info!(event)
    user = User.from_discord_event(event)

    event << "Your username is #{user.username} and your Discord ID is #{user.discord_id}."
    event << "Your count is #{user.count}. Your created at is #{user.created_at}. Your updated at is #{user.updated_at}."
  end

  def handle_count!(event)
    user = User.from_discord_event(event)

    user.count += 1
    user.save!

    event << "You have used this command #{user.count} times now."
  end

  def handle_michelle!(event)
    user = User.from_discord_event(event)

    if user.has_completed_michelle_obama_challenge_today?
      event << 'You have already completed the Michelle Obama challenge today.'
    else
      user.complete_michelle_obama_challenge_for_today!
      event << 'You have completed the Michelle Obama challenge for today!'
    end

    challenge_entries = user.michelle_obama_challenge_entries

    event << "You have completed the Michelle Obama challenge #{challenge_entries.size} times."
    event << 'Here are the dates you have completed the challenge:'
    challenge_entries.each do |entry|
      event << "- #{entry.date}"
    end
    event << 'Keep up the good work! - Michelle Obama'
  end
end
