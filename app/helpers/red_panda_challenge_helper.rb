module RedPandaChallengeHelper
  def show_michelle_obama_challenge_stats!
    challenge_entries = user.michelle_obama_challenge_entries
    streak = calculate_current_michelle_obama_challenge_streak

    event << "You have completed the Michelle Obama challenge #{challenge_entries.size} times."
    event << "Your current streak is #{streak} #{'days'.pluralize(streak)}."
    event << ""
    event << 'This week:'

    date_range = (Date.today - 7) .. (Date.today)

    date_range.each do |date|
      formatted_date = date.strftime('%m-%d %a')
      challenge_was_completed = challenge_entries.any? { |entry| entry.date == date }
      
      if challenge_was_completed
        event << "- #{formatted_date} ✔️"
      else
        event << "- #{formatted_date}"
      end
    end
  end

  def calculate_current_michelle_obama_challenge_streak
    streak = 0
    challenge_entries = user.michelle_obama_challenge_entries
    challenge_entries.reverse_each.with_index do |entry, index|
      streak += 1
      break unless entry.date == Date.today - index
    end
    streak
  end
end
