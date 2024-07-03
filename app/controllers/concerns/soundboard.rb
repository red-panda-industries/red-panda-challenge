require 'timeout'

module Soundboard
  VOICE_CHANNEL_TIMEOUT_SECONDS = 5

  def play_wow_ethan_sound!
    play_sound!('wow_ethan.opus')
  end

  private

  def play_sound!(file_name)
    sound_path = File.join(::Application.sounds_directory, file_name).to_s
    logger.info "Attempting to play sound #{sound_path.inspect}"

    flush_message_buffer!

    voice_channel = connect_to_voice_channel!
    return unless voice_channel

    if file_name.end_with?('.dca')
      event.voice.play_dca(sound_path)
    else
      event.voice.play_file(sound_path)
    end

    leave_voice_channel!

    logger.info "\e[1m\e[32mPlayed sound #{sound_path.inspect} in voice channel #{voice_channel.name.inspect}\e[0m"
  end

  # returns the voice channel the bot is connected to,
  # or nil if the user is not in a voice channel,
  # or nil if the bot times out while connecting
  def connect_to_voice_channel!
    channel = event.user.voice_channel

    if channel.nil?
      logger.warn "User #{event.user.name.inspect} (#{event.user.id}) is not in a voice channel"
      return nil
    end

    logger.debug "Found voice channel #{channel.name.inspect}"
    begin
      Timeout::timeout(VOICE_CHANNEL_TIMEOUT_SECONDS) do
        bot.voice_connect(channel)
      end
      logger.debug "\e[1;32mConnected to voice channel #{channel.name.inspect}\e[0m"
    rescue Timeout::Error
      logger.warn "\e[1;33mTimed out while connecting to voice channel #{channel.name.inspect}\e[0m"
      return nil
    end
    
    channel
  end

  def leave_voice_channel!
    bot.voice_destroy(event.server.id)
    logger.debug "\e[1;32mLeft voice channel #{event.user.voice_channel.name.inspect}\e[0m"
  end

  def flush_message_buffer!
    buffer = event.drain_into('')
    logger.debug "Flushed message buffer: #{buffer.inspect}"
    event.send_message(buffer) unless buffer.empty?
    nil
  end
end
