module Soundboard
  def play_wow_ethan_sound!
    play_sound!('wow_ethan.opus')
  end

  private

  def play_sound!(file_name)
    sound_path = File.join(::Application.sounds_directory, file_name).to_s
    logger.info "Attempting to play sound #{sound_path.inspect}"

    voice_channel = connect_to_voice_channel!
    return unless voice_channel

    flush_message_buffer!

    if file_name.end_with?('.dca')
      event.voice.play_dca(sound_path)
    else
      event.voice.play_file(sound_path)
    end

    logger.info "\e[1m\e[32mPlayed sound #{sound_path.inspect} in voice channel #{voice_channel.name.inspect}\e[0m"
  end

  def connect_to_voice_channel!
    channel = event.user.voice_channel

    if channel
      logger.debug "Found voice channel #{channel.name.inspect}"
      bot.voice_connect(channel)
      logger.debug "\e[1m\e[32mConnected to voice channel #{channel.name.inspect}\e[0m"
    else
      logger.warn 'User is not in a voice channel'
    end

    channel
  end

  def flush_message_buffer!
    buffer = event.drain_into('')
    logger.debug "Flushed message buffer: #{buffer.inspect}"
    event.send_message(buffer) unless buffer.empty?
    nil
  end
end
