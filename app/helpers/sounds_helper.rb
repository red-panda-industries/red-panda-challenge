module SoundsHelper
  attr_reader :voice_bot

  def play_wow_ethan_sound!(event)
    play_sound!(event:, file_name: 'wow_ethan.mp3')
  end

  private

  def play_sound!(event:, file_name:)
    sound_file = File.join(::Application.sounds_directory, file_name)

    voice_bot = event.voice
    return event << 'You must be in a voice channel to play a sound.' unless voice_bot

    voice_bot.play_file(sound_file)
  end
end