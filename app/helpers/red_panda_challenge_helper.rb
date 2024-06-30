module RedPandaChallengeHelper
  def show_michelle_stats!
    challenge_entries = user.cached_michelle_obama_challenge_entries
    current_streak = user.current_michelle_obama_challenge_streak
    longest_streak = user.longest_michelle_obama_challenge_streak

    event << "You have completed the Michelle Obama challenge #{challenge_entries.count} times."
    event << "Your current streak is #{current_streak.length} #{'days'.pluralize(current_streak.length)} and started on #{format_date(current_streak.last.date)}."

    if current_streak.first == longest_streak.first
      event << 'This is your longest streak!'
    else
      event << "Your longest streak was #{longest_streak.length} #{'days'.pluralize(longest_streak.length)} and lasted from #{format_date(longest_streak.first.date)} to #{format_date(longest_streak.last.date)}."
    end

    show_weekly_michelle_stats!
  end

  def show_weekly_michelle_stats!
    challenge_entries = user.cached_michelle_obama_challenge_entries
    completed_dates = challenge_entries.map(&:date).to_set

    event << '### Weekly Stats'

    date_range = (Date.today.beginning_of_week .. Date.today.end_of_week)
    date_range.each do |date|
      if completed_dates.include?(date)
        event << "- #{format_date(date)} ✔️ Completed"
      else
        event << "- #{format_date(date)}"
      end
    end
  end

  def format_date(date)
    date.strftime('%m-%d %a')
  end
end
