module SoundsConcern
  def play_wow_ethan_sound!(event)
    play_sound!(event:, file_name: 'wow_ethan.mp3')
  end

  private

  def play_sound!(event:, file_name:)
    sound_file = File.join(::Application.sounds_directory, file_name).to_s
    logger.info "Playing sound: #{sound_file.inspect}"

    channel = event.user.voice_channel

    if channel.nil?
      logger.warn "User #{event.user.name.inspect} (#{event.user.id}) is not in a voice channel"
      return
    end
    logger.debug "↳ Found voice channel: #{channel.name.inspect} on server #{channel.server.name.inspect}"

    bot.voice_connect(channel)
    logger.debug "↳ Connected to voice channel: #{channel.name.inspect} on server #{channel.server.name.inspect}"

    flush_message_buffer!(event)

    event.voice.play_file(sound_file)
    logger.info "Played sound: #{sound_file.inspect}"
  end

  def flush_message_buffer!(event)
    buffer = event.drain_into('')
    logger.debug "Flushing message buffer: #{buffer.inspect}"
    event.send_message(buffer) unless buffer.empty?
  end
end
