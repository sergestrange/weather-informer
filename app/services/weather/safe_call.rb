# frozen_string_literal: true

module Weather
  ##
  # SafeCall оборачивает вызов в circuit breaker (через Circuitbox).
  # Если схема разомкнута или вызов завершился с ошибкой из списка
  # обрабатываемых исключений, пробрасывается Weather::ProviderError.
  #
  # Пример:
  #   circuit = Circuitbox.circuit(:open_meteo, exceptions: [Faraday::Error])
  #   safe = Weather::SafeCall.new(circuit: circuit)
  #   safe.call { provider.forecast(lat: 55.7, lon: 37.6) }
  #
  class SafeCall
    def initialize(circuit:) = (@circuit = circuit)

    ##
    # Выполняет блок в circuit breaker.
    #
    # @yield Выполняемый блок (например вызов провайдера)
    # @return [Object] результат выполнения блока, если успешен
    # @raise [Weather::ProviderError] если схема открыта или произошла ошибка
    #
    def call(&)
      @circuit.run(&)
    rescue Circuitbox::Error, *Array(@circuit.options[:exceptions])
      raise Weather::ProviderError, 'circuit_open_or_failure'
    end
  end
end
