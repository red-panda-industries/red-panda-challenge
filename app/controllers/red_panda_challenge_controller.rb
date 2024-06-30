class RedPandaChallengeController < ApplicationController
  include RedPandaChallengeHelper
  include Soundboard

  def show_user_info
    event << "Your username is #{user.username}."
    event << "Your Discord ID is #{user.discord_id}."
    event << "Your count is #{user.count}."
    event << "Your user was created at #{user.created_at}."
    event << "Your user was last updated at #{user.updated_at}."
    event << "You have completed the Michelle Obama challenge #{user.michelle_obama_challenge_entries.count} times."
  end

  def increment_user_count
    user.count += 1
    user.save!

    event << "You have used this command #{user.count} times now."
  end

  def michelle_obama_challenge
    if user.has_completed_michelle_obama_challenge_today?
      event << 'You have already completed the Michelle Obama challenge today.'
    else
      user.complete_michelle_obama_challenge_for_today!
      event << 'You have completed the Michelle Obama challenge for today!'
    end

    show_michelle_obama_challenge_stats!
    event << 'Keep up the good work! - Michelle Obama'

    play_wow_ethan_sound!
  end
end
