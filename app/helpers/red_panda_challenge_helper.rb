module RedPandaChallengeHelper
  def display_michelle_obama_challenge_stats!(user:, event:)
    challenge_entries = user.michelle_obama_challenge_entries

    event << "You have completed the Michelle Obama challenge #{challenge_entries.size} times."
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
end
