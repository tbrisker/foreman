# Mixin to update the puppetclass hosts counters of any class affected by changes to
# inheritance which affect the count - directly or by changes to hostgroups or config_groups
module UpdatePuppetclassesCounters
  extend ActiveSupport::Concern

  included do
    # update puppetclass count when changed directly
    def update_puppetclass_hosts_count(puppetclass)
      puppetclass.update_hosts_count if puppetclass.present?
    end

    #updates counters for all puppetclasses affected indirectly
    def update_all_puppetclasses_hosts_count(relation = nil)
      unless self.is_a?(ConfigGroup) # if called for Host or Hostgroup
        config_groups.each(&:update_all_puppetclasses_hosts_count) if config_groups.present?
      end
      if self.is_a?(Host::Managed) && hostgroup.present?
        hostgroup.update_all_puppetclasses_hosts_count
      end
      if self.is_a?(Hostgroup) #Update all ancestors for hostgroup recursively
        parent.update_all_puppetclasses_hosts_count unless is_root?
      end
      if puppetclasses.present?
        puppetclasses.each(&:update_hosts_count)
      end
    end
  end
end
