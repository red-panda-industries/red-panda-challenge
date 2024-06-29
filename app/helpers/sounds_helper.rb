module SoundsHelper
  def play_wow_ethan_sound!(event)
    play_sound!(event:, file_name: 'wow_ethan.mp3')
  end

  private

  def play_sound!(event:, file_name:)
    sound_file = File.join(::Application.sounds_directory, file_name)

    voice_bot = event.voice
    if voice_bot.nil?
      event << "Can't play `#{file_name}`: You must be in a voice channel to play a sound."
      logger.warn "Tried to play a sound #{file_name.inspect} without being in a voice channel: from message #{event.message.content.inspect} invoked by #{event.user.username} (#{event.user.id})"
      return
    end

    voice_bot.play_file(sound_file)
  end
end