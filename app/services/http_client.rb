# frozen_string_literal: true

class HttpClient
  DEFAULT_TIMEOUT = 5

  def self.build(base_url:)
    Faraday.new(url: base_url) do |f|
      f.request :retry, max: 2, interval: 0.25, backoff_factor: 2,
                        retry_statuses: [429, 500, 502, 503, 504],
                        methods: %i[get]
      f.options.timeout      = ENV.fetch('HTTP_TIMEOUT', DEFAULT_TIMEOUT).to_i
      f.options.open_timeout = 2
      f.response :raise_error
      f.adapter Faraday.default_adapter
    end
  end
end
