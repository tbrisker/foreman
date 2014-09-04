require 'test_helper'

class PuppetclassTest < ActiveSupport::TestCase
  setup do
    User.current = users :admin
  end

  test "name can't be blank" do
    puppet_class = Puppetclass.new
    assert !puppet_class.save
  end

  test "name can't contain trailing white spaces" do
    puppet_class = Puppetclass.new :name => "   test     class   "
    assert !puppet_class.name.squeeze(" ").empty?
    assert !puppet_class.save

    puppet_class.name.squeeze!(" ")
    assert puppet_class.save
  end

  test "name must be unique" do
    puppet_class = Puppetclass.new :name => "test class"
    assert puppet_class.save

    other_puppet_class = Puppetclass.new :name => "test class"
    assert !other_puppet_class.save
  end

  test "looking for a nonexistent host returns no puppetclasses" do
    assert_equal [], Puppetclass.search_for("host = imaginaryhost.nodomain.what")
  end

  test "user with create external_variables permission can create smart variable for puppetclass" do
    @one = users(:one)
    # add permission for user :one
    as_admin do
      filter1 = FactoryGirl.build(:filter)
      filter1.permissions = Permission.find_all_by_name(['create_external_variables'])
      filter2 = FactoryGirl.build(:filter)
      filter2.permissions = Permission.find_all_by_name(['edit_puppetclasses'])
      role = Role.find_or_create_by_name :name => "testing_role"
      role.filters = [ filter1, filter2 ]
      role.save!
      filter1.role = role
      filter1.save!
      filter2.role = role
      filter2.save!
      @one.roles = [ role ]
      @one.save!
    end
    as_user :one do
      nested_lookup_key_params = {:new_1372154591368 => {:key=>"test_param", :key_type=>"string", :default_value => "7777", :path =>"fqdn\r\nhostgroup\r\nos\r\ndomain"}}
      assert Puppetclass.first.update_attributes(:lookup_keys_attributes => nested_lookup_key_params)
    end
  end

  test "create puppetclass with smart variable as nested attribute" do
    as_admin do
      puppetclass = Puppetclass.new(:name => "PuppetclassWithSmartVariable", :lookup_keys_attributes => {"new_1372154591368" => {:key => 'smart_variable1'}})
      assert puppetclass.save
      assert_equal Puppetclass.unscoped.last.id, LookupKey.unscoped.last.puppetclass_id
    end
  end

  test "Puppetclass singularize from custom inflection" do
    assert_equal "Puppetclass", "Puppetclass".singularize
    assert_equal "Puppetclass", "Puppetclasses".singularize
    assert_equal "puppetclass", "puppetclass".singularize
    assert_equal "puppetclass", "puppetclasses".singularize
  end

  test "Puppetclass classify from custom inflection" do
    assert_equal "Puppetclass", "Puppetclass".classify
    assert_equal "Puppetclass", "Puppetclasses".classify
    assert_equal "Puppetclass", "puppetclass".classify
    assert_equal "Puppetclass", "puppetclasses".classify
  end

  test "should update hosts_count on direct host assignment" do
    pc1 = FactoryGirl.create(:puppetclass)
    host = FactoryGirl.create(:host, :with_puppetclass)
    pc2 = host.puppetclasses.first
    host.puppetclasses << pc1
    assert_equal 1, pc1.hosts_count
    assert_equal 1, pc2.hosts_count
    host.puppetclasses.delete([pc1,pc2])
    assert_equal 0, pc1.hosts_count
    assert_equal 0, pc2.hosts_count
  end

  test "should update hosts_count via hostgroup" do
    hg = FactoryGirl.create(:hostgroup, :with_puppetclass)
    host = FactoryGirl.create(:host, :hostgroup => hg, :environment => hg.environment)
    assert_equal 1, hg.puppetclasses.first.hosts_count
    hg.hosts.delete(host)
    assert_equal 0, hg.puppetclasses.first.hosts_count
  end

  test "should update hosts_count via config group" do
    pc = FactoryGirl.create(:puppetclass)
    hg = FactoryGirl.create(:hostgroup, :with_config_group)
    cg = hg.config_groups.first
    cg.puppetclasses << pc
    host = FactoryGirl.create(:host, :hostgroup => hg, :environment => hg.environment)
    assert_equal 1, pc.hosts_count
    hg.config_groups.delete(cg)
    assert_equal 0, pc.hosts_count
  end

end
