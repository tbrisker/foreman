class FixPuppetclassHostsCounters < ActiveRecord::Migration
  def up
    Rake::Task['puppet:fix_hosts_counts'].invoke
  end

  def down
  end
end
