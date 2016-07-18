class Architecture < ActiveRecord::Base
  include Authorizable
  extend FriendlyId
  friendly_id :name
  include Parameterizable::ByIdName

  attr_accessible :name, :host_names, :host_ids, :hostgroup_ids,
    :hostgroup_names, :image_names, :image_ids, :operatingsystem_ids,
    :operatingsystem_names

  before_destroy EnsureNotUsedBy.new(:hosts, :hostgroups)
  validates_lengths_from_database

  has_many_hosts
  has_many :hostgroups
  has_many :images, :dependent => :destroy
  has_and_belongs_to_many :operatingsystems
  validates :name, :presence => true, :uniqueness => true, :no_whitespace => true
  audited :allow_mass_assignment => true

  scoped_search :on => :name, :complete_value => :true
end
