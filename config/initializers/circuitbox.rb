# frozen_string_literal: true

# Можно расширить на нескольких поставщиков данных по API и делать fallback в Weather::SafeCall
CIRCUITS = {
  open_meteo: Circuitbox.circuit(:open_meteo,
                                 exceptions: [Faraday::TimeoutError, Faraday::ConnectionFailed, Faraday::ServerError],
                                 sleep_window: 60, volume_threshold: 5, error_threshold: 50, time_window: 60)
}.freeze

Circuitbox.configure do |config|
  config.default_circuit_store = Circuitbox::MemoryStore.new
  config.default_notifier = Circuitbox::Notifier::Null.new
end
