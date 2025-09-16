# frozen_string_literal: true

module Weather
  class SafeCall
    def initialize(circuit:) = (@circuit = circuit)

    def call(&)
      @circuit.run(&)
    rescue Circuitbox::Error, *Array(@circuit.options[:exceptions])
      raise Weather::ProviderError, 'circuit_open_or_failure'
    end
  end
end
