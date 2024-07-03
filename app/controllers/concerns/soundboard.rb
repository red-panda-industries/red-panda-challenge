require 'timeout'

module Soundboard
  VOICE_CHANNEL_TIMEOUT_SECONDS = 5

  # Mutexes to be created for each server, to prevent multiple sounds from playing at once on the same server.
  # This is necessary because the bot can only be connected to one voice channel at a time per server.
  @@server_mutexes = {}

  def play_wow_ethan_sound!
    play_sound!('wow_ethan.opus')
  end

  private

  def play_sound!(file_name)
    flush_message_buffer!

    logger.info "Attempting to play sound #{file_name.inspect}"
    logger.info 'Waiting for soundboard mutex'
    server_mutex.synchronize do
      logger.info 'Acquired soundboard mutex'
      connect_to_voice_channel! or return
      begin
        play_sound_file!(file_name)
      rescue StandardError => e
        logger.error "Error during sound playback: #{e.message}"
      ensure
        leave_voice_channel!
      end
    end
  end

  def play_sound_file!(file_name)
    sound_path = File.join(::Application.sounds_directory, file_name).to_s

    if file_name.end_with?('.dca')
      event.voice.play_dca(sound_path)
    else
      event.voice.play_file(sound_path)
    end

    logger.info "\e[1m\e[32mPlayed sound #{sound_path.inspect} in voice channel #{event.user.voice_channel.name.inspect}\e[0m"
  end

  # returns the voice channel the bot is connected to,
  # or nil if the user is not in a voice channel,
  # or nil if the bot times out while connecting
  def connect_to_voice_channel!
    channel = event.user.voice_channel

    if channel.nil?
      logger.warn 'User is not in a voice channel'
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
    if buffer.present?
      event.send_message(buffer) 
      logger.debug "Flushed message buffer: #{buffer.inspect}"
    end
    return nil
  end

  def server_mutex
    @@server_mutexes[event.server.id] ||= Mutex.new
  end
end
