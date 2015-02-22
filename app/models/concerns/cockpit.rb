module Cockpit
  extend ActiveSupport::Concern

  included do
    def cockpit_enabled?
      # TODO: Only actually send the request if OS supports cockpit
      return false unless primary_interface.fqdn.present?
      Timeout::timeout(5) do
        'cockpit' == JSON.parse(RestClient.get("#{primary_interface.fqdn}:9090/ping"))['service']
      end
    rescue => e
      logger.warn "Tried to contact Cockpit for host #{name} but failed: #{e}"
      logger.debug e.backtrace.join("\n")
      false
    end
  end
end
