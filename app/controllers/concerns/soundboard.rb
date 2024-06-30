module Soundboard
  def play_wow_ethan_sound!
    play_sound!('wow_ethan.mp3')
  end

  private

  def play_sound!(file_name)
    logger.info "Attempting to play sound: #{file_name.inspect}"

    connect_to_voice_channel! or return
    flush_message_buffer!

    sound_path = File.join(::Application.sounds_directory, file_name).to_s

    event.voice.play_file(sound_path)
    logger.info "Played sound: #{sound_path.inspect}"
  end

  def connect_to_voice_channel!
    channel = event.user.voice_channel

    if channel
      logger.debug "↳ Found voice channel: #{channel.name.inspect}"
      bot.voice_connect(channel)
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
