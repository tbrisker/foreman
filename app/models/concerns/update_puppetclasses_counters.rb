module PuppetclassesCounters
  extend ActiveSupport::Concern

  included do
    has_many :puppetclasses, :through => :"#{model_name.underscore}_classes"

    # Update counters for all Puppetclasses affected indirectly
    def update_all_puppetclasses_hosts_count
      puppetclasses.each(&:update_hosts_count)
    end
  end
end
